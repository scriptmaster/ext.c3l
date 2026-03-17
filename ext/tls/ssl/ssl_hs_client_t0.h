/*
 * ssl_hs_client_t0.h
 *
 * ssl_hs_client.t0의 모든 T0 단어와 cc: 단어를 C로 변환한 파일.
 *
 * 파일 구성
 * ---------
 *  1. client cc: 래퍼 함수들    (CTX를 사용하는 cc: 단어들)
 *  2. addr-ctx: 오프셋 매크로
 *  3. 확장 길이 계산 함수들      (ext-reneg-length, ext-sni-length, ...)
 *  4. ClientHello 작성          (write-ClientHello)
 *  5. ServerHello 파싱          (read-ServerHello, read-server-* 확장들)
 *  6. ServerKeyExchange 파싱    (read-ServerKeyExchange)
 *  7. CertificateRequest 파싱   (read-contents-CertificateRequest)
 *  8. 쓰기 함수들               (write-ClientKeyExchange, write-CertificateVerify)
 *  9. 메인 코루틴               (do-handshake, main)
 *
 * 의존성
 * ------
 *  ssl_hs_common_t0.h  (3단계: hs_run_ctx, 공통 T0 단어들)
 */

#ifndef SSL_HS_CLIENT_T0_H
#define SSL_HS_CLIENT_T0_H

#include "ssl_hs_common_t0.h"

/* ======================================================================
 * CTX 파생 헬퍼
 * ====================================================================== */
static inline br_ssl_client_context *
hs_cctx(hs_run_ctx *ctx)
{
    return (br_ssl_client_context *)ctx->eng;
}

/* ======================================================================
 * 섹션 1: client cc: 래퍼 함수들
 * ====================================================================== */

/*
 * cc: ext-ALPN-length ( -- len )
 *
 * ALPN 확장 전체 길이(헤더 포함). 이름이 없으면 0.
 */
static inline uint32_t
hs_ext_ALPN_length(const br_ssl_engine_context *eng)
{
    size_t u, len;

    if (eng->protocol_names_num == 0) return 0;
    len = 6;
    for (u = 0; u < eng->protocol_names_num; u++) {
        len += 1 + strlen(eng->protocol_names[u]);
    }
    return (uint32_t)len;
}

/*
 * cc: set-server-curve ( -- )
 *
 * X.509 엔진에서 서버 공개키의 EC 커브 ID를 읽어 server_curve에 저장한다.
 */
static inline void
hs_set_server_curve(hs_run_ctx *ctx)
{
    br_ssl_client_context *cctx = hs_cctx(ctx);
    const br_x509_class   *xc   = *(ctx->eng->x509ctx);
    const br_x509_pkey    *pk   = xc->get_pkey(ctx->eng->x509ctx, NULL);

    cctx->server_curve =
        (pk->key_type == BR_KEYTYPE_EC) ? pk->key.ec.curve : 0;
}

/*
 * cc: verify-SKE-sig ( hash use-rsa sig-len -- err )
 *
 * T0 원문:
 *   size_t sig_len = T0_POP();
 *   int use_rsa    = T0_POPi();
 *   int hash       = T0_POPi();
 *   T0_PUSH(verify_SKE_sig(CTX, hash, use_rsa, sig_len));
 */
static inline int
hs_verify_SKE_sig(hs_run_ctx *ctx, int hash, int use_rsa, size_t sig_len)
{
    return verify_SKE_sig(hs_cctx(ctx), hash, use_rsa, sig_len);
}

/*
 * cc: do-rsa-encrypt ( prf_id -- nlen )
 *
 * T0 원문:
 *   x = make_pms_rsa(CTX, prf_id);
 *   if (x < 0) { br_ssl_engine_fail(ENG, -x); T0_CO(); }
 *   else T0_PUSH(x);
 */
static inline int
hs_do_rsa_encrypt(hs_run_ctx *ctx, int prf_id)
{
    int x = make_pms_rsa(hs_cctx(ctx), prf_id);
    if (x < 0) {
        hs_fail(ctx->eng, -x);
    }
    return x;
}

/*
 * cc: do-ecdh ( ecdhe prf_id -- ulen )
 *
 * T0 원문:
 *   x = make_pms_ecdh(CTX, ecdhe, prf_id);
 *   if (x < 0) { br_ssl_engine_fail(ENG, -x); T0_CO(); }
 *   else T0_PUSH(x);
 */
static inline int
hs_do_ecdh_client(hs_run_ctx *ctx, unsigned ecdhe, int prf_id)
{
    int x = make_pms_ecdh(hs_cctx(ctx), ecdhe, prf_id);
    if (x < 0) {
        hs_fail(ctx->eng, -x);
    }
    return x;
}

/*
 * cc: do-static-ecdh ( prf-id -- )
 */
static inline void
hs_do_static_ecdh_client(hs_run_ctx *ctx, int prf_id)
{
    if (make_pms_static_ecdh(hs_cctx(ctx), prf_id) < 0) {
        hs_fail(ctx->eng, BR_ERR_INVALID_ALGORITHM);
    }
}

/*
 * cc: do-client-sign ( -- sig_len )
 */
static inline size_t
hs_do_client_sign(hs_run_ctx *ctx)
{
    size_t sig_len = make_client_sign(hs_cctx(ctx));
    if (sig_len == 0) {
        hs_fail(ctx->eng, BR_ERR_INVALID_ALGORITHM);
    }
    return sig_len;
}

/*
 * cc: anchor-dn-start-name-list / start-name / append-name / end-name / end-name-list
 *
 * 클라이언트 인증서 핸들러 vtable의 DN 목록 처리 래퍼들.
 */
static inline void
hs_anchor_dn_start_name_list(hs_run_ctx *ctx)
{
    br_ssl_client_context *cctx = hs_cctx(ctx);
    if (cctx->client_auth_vtable != NULL)
        (*cctx->client_auth_vtable)->start_name_list(cctx->client_auth_vtable);
}

static inline void
hs_anchor_dn_start_name(hs_run_ctx *ctx, size_t len)
{
    br_ssl_client_context *cctx = hs_cctx(ctx);
    if (cctx->client_auth_vtable != NULL)
        (*cctx->client_auth_vtable)->start_name(cctx->client_auth_vtable, len);
}

static inline void
hs_anchor_dn_append_name(hs_run_ctx *ctx, size_t len)
{
    br_ssl_client_context *cctx = hs_cctx(ctx);
    if (cctx->client_auth_vtable != NULL)
        (*cctx->client_auth_vtable)->append_name(
            cctx->client_auth_vtable, ctx->eng->pad, len);
}

static inline void
hs_anchor_dn_end_name(hs_run_ctx *ctx)
{
    br_ssl_client_context *cctx = hs_cctx(ctx);
    if (cctx->client_auth_vtable != NULL)
        (*cctx->client_auth_vtable)->end_name(cctx->client_auth_vtable);
}

static inline void
hs_anchor_dn_end_name_list(hs_run_ctx *ctx)
{
    br_ssl_client_context *cctx = hs_cctx(ctx);
    if (cctx->client_auth_vtable != NULL)
        (*cctx->client_auth_vtable)->end_name_list(cctx->client_auth_vtable);
}

/*
 * cc: get-client-chain ( auth_types -- )
 *
 * 클라이언트 인증서 핸들러에 auth_types를 넘겨 인증서 체인을 얻는다.
 */
static inline void
hs_get_client_chain(hs_run_ctx *ctx, uint32_t auth_types)
{
    br_ssl_client_context *cctx = hs_cctx(ctx);

    if (cctx->client_auth_vtable != NULL) {
        br_ssl_client_certificate ux;
        (*cctx->client_auth_vtable)->choose(
            cctx->client_auth_vtable, cctx, auth_types, &ux);
        cctx->auth_type      = (unsigned char)ux.auth_type;
        cctx->hash_id        = (unsigned char)ux.hash_id;
        ctx->eng->chain      = ux.chain;
        ctx->eng->chain_len  = ux.chain_len;
    } else {
        cctx->hash_id       = 0;
        ctx->eng->chain_len = 0;
    }
}

/* ======================================================================
 * 섹션 2: addr-ctx: 오프셋 매크로
 * ====================================================================== */

#define OFF_CLI_min_clienthello_len  \
    offsetof(br_ssl_client_context, min_clienthello_len)
#define OFF_CLI_hashes   offsetof(br_ssl_client_context, hashes)
#define OFF_CLI_auth_type offsetof(br_ssl_client_context, auth_type)
#define OFF_CLI_hash_id   offsetof(br_ssl_client_context, hash_id)

/* ======================================================================
 * 섹션 3: 확장 길이 계산 함수들
 * ====================================================================== */

/*
 * : ext-reneg-length ( -- n )
 *   addr-reneg get8 dup if 1 - 17 * else drop 5 then ;
 *
 * reneg==0 (최초): 5바이트 (타입2 + 길이2 + 데이터1)
 * reneg!=0 (재협상): (reneg-1)*17  → reneg==2이면 17바이트
 * reneg==1 (서버 미지원): 0바이트
 */
static inline uint32_t
hs_ext_reneg_length(const br_ssl_engine_context *eng)
{
    uint8_t r = hs_get8(eng, offsetof(br_ssl_engine_context, reneg));
    return r ? (uint32_t)(r - 1) * 17 : 5;
}

/*
 * : ext-sni-length ( -- len )
 *   addr-server_name strlen dup if 9 + then ;
 *
 * 서버 이름이 없으면 0, 있으면 이름 길이 + 9.
 */
static inline uint32_t
hs_ext_sni_length(const br_ssl_engine_context *eng)
{
    uint32_t len = hs_strlen(eng,
        offsetof(br_ssl_engine_context, server_name));
    return len ? len + 9 : 0;
}

/*
 * : ext-frag-length ( -- len )
 *   addr-log_max_frag_len get8 14 = if 0 else 5 then ;
 *
 * 기본값(14=16384바이트)이면 확장 불필요.
 */
static inline uint32_t
hs_ext_frag_length(const br_ssl_engine_context *eng)
{
    return (hs_get8(eng, offsetof(br_ssl_engine_context,
                    log_max_frag_len)) == 14) ? 0 : 5;
}

/*
 * : ext-signatures-length ( -- len )
 *   supported-hash-functions { num } drop 0
 *   supports-rsa-sign? if num + then
 *   supports-ecdsa?    if num + then
 *   dup if 1 << 6 + then ;
 *
 * 각 알고리즘(RSA, ECDSA)마다 지원하는 해시 수만큼 2바이트 항목이 생긴다.
 * 총 바이트 = (항목 수 * 2) + 6 (타입2 + 길이2 + 목록길이2)
 */
static inline uint32_t
hs_ext_signatures_length(const br_ssl_engine_context *eng)
{
    uint32_t num, hx;
    hs_supported_hash_functions(eng, &hx, &num);

    uint32_t total = 0;
    if (hs_supports_rsa_sign(eng)) total += num;
    if (hs_supports_ecdsa(eng))    total += num;
    return total ? (total * 2) + 6 : 0;
}

/*
 * : ext-supported-curves-length ( -- len )
 *   supported-curves dup if
 *     0 { x }
 *     begin dup while dup 1 and x + >x 1 >> repeat
 *     drop x 1 << 6 +
 *   then ;
 *
 * 비트마스크에서 1인 비트(= 지원 커브) 수를 세어 2바이트씩 계산.
 */
static inline uint32_t
hs_ext_supported_curves_length(const br_ssl_engine_context *eng)
{
    uint32_t curves = hs_supported_curves(eng);
    if (!curves) return 0;

    /* 비트 카운트 */
    uint32_t cnt = 0, tmp = curves;
    while (tmp) { cnt += tmp & 1; tmp >>= 1; }
    return cnt * 2 + 6;
}

/*
 * : ext-point-format-length ( -- len )
 *   supported-curves if 6 else 0 then ;
 */
static inline uint32_t
hs_ext_point_format_length(const br_ssl_engine_context *eng)
{
    return hs_supported_curves(eng) ? 6 : 0;
}

/* ======================================================================
 * 섹션 4: ClientHello 작성
 * ====================================================================== */

/*
 * : write-hashes ( sign -- )
 *
 * 지원하는 해시 함수를 (hash_id, sign) 쌍으로 출력한다.
 * 우선순위: SHA-256(4), SHA-224(3), SHA-384(5), SHA-512(6), SHA-1(2)
 */
static void
hs_write_hashes(hs_run_ctx *ctx, int sign)
{
    br_ssl_engine_context *eng = ctx->eng;
    uint32_t hx, dummy;
    hs_supported_hash_functions(eng, &hx, &dummy);

    if (hx & 0x10) { hs_write8(ctx, 4); hs_write8(ctx, (unsigned char)sign); }
    if (hx & 0x08) { hs_write8(ctx, 3); hs_write8(ctx, (unsigned char)sign); }
    if (hx & 0x20) { hs_write8(ctx, 5); hs_write8(ctx, (unsigned char)sign); }
    if (hx & 0x40) { hs_write8(ctx, 6); hs_write8(ctx, (unsigned char)sign); }
    if (hx & 0x04) { hs_write8(ctx, 2); hs_write8(ctx, (unsigned char)sign); }
}

/*
 * : write-ClientHello ( -- )
 *
 * 확장 목록:
 *   0xFF01  Secure Renegotiation
 *   0x0000  SNI
 *   0x0001  Max Fragment Length
 *   0x000D  Signature Algorithms
 *   0x000A  Supported Curves (Curve25519 우선)
 *   0x000B  Supported Point Formats
 *   0x0010  ALPN
 *   0x0015  Padding (min_clienthello_len 맞춤용)
 */
static void
hs_write_ClientHello(hs_run_ctx *ctx)
{
    br_ssl_engine_context *eng  = ctx->eng;

    /* 확장 길이 계산 */
    uint32_t ext_reneg  = hs_ext_reneg_length(eng);
    uint32_t ext_sni    = hs_ext_sni_length(eng);
    uint32_t ext_frag   = hs_ext_frag_length(eng);
    uint32_t ext_sig    = hs_ext_signatures_length(eng);
    uint32_t ext_curves = hs_ext_supported_curves_length(eng);
    uint32_t ext_pts    = hs_ext_point_format_length(eng);
    uint32_t ext_alpn   = hs_ext_ALPN_length(eng);
    uint32_t total_ext  = ext_reneg + ext_sni + ext_frag
                        + ext_sig + ext_curves + ext_pts + ext_alpn;

    /* 기본 ClientHello 길이 계산 */
    uint8_t  sid_len    = hs_get8(eng,
        offsetof(br_ssl_engine_context, session) +
        offsetof(br_ssl_session_parameters, session_id_len));
    uint8_t  suites_num = hs_get8(eng,
        offsetof(br_ssl_engine_context, suites_num));
    uint32_t base_len   = 39 + (uint32_t)sid_len + (uint32_t)suites_num * 2
                        + (total_ext ? 2 + total_ext : 0);

    /* 패딩 확장 계산 */
    int32_t  ext_padding = -1;  /* -1 = 패딩 없음 */
    uint16_t min_len = hs_get16(eng, (uint32_t)OFF_CLI_min_clienthello_len);
    if (min_len > 0 && base_len < (uint32_t)min_len) {
        int32_t diff = (int32_t)min_len - (int32_t)base_len;
        if (total_ext == 0) { diff -= 2; total_ext += 2; }
        diff -= 4;  /* 패딩 확장 헤더 4바이트 */
        if (diff < 0) diff = 0;
        ext_padding  = diff;
        total_ext   += 4 + (uint32_t)diff;
        base_len    += 4 + (uint32_t)diff + (total_ext == (uint32_t)(4 + diff + 2) ? 2 : 0);
    }

    /* message type */
    hs_write8(ctx, 1);

    /* length */
    uint32_t msg_len = 39 + (uint32_t)sid_len + (uint32_t)suites_num * 2
                     + (total_ext ? 2 + total_ext : 0)
                     + (ext_padding >= 0 ? 0 : 0);  /* already included */
    hs_write24(ctx, msg_len);

    /* protocol version */
    hs_write16(ctx, hs_get16(eng,
        offsetof(br_ssl_engine_context, version_max)));

    /* client random */
    hs_bzero(eng, offsetof(br_ssl_engine_context, client_random), 4);
    hs_mkrand(eng, offsetof(br_ssl_engine_context, client_random) + 4, 28);
    hs_write_blob(ctx,
        (uint32_t)offsetof(br_ssl_engine_context, client_random), 32);

    /* session ID */
    hs_write_blob_head8(ctx,
        (uint32_t)offsetof(br_ssl_engine_context, session) +
        (uint32_t)offsetof(br_ssl_session_parameters, session_id),
        (uint32_t)sid_len);

    /* cipher suites */
    hs_write16(ctx, (uint32_t)suites_num * 2);
    {
        uint32_t buf_off = (uint32_t)offsetof(br_ssl_engine_context, suites_buf);
        int i;
        for (i = 0; i < suites_num; i++) {
            uint16_t s = hs_get16(eng, buf_off + (uint32_t)(i * 2));
            if (!hs_suite_supported(s)) hs_fail(eng, BR_ERR_BAD_CIPHER_SUITE);
            hs_write16(ctx, s);
        }
    }

    /* compression methods: null only */
    hs_write8(ctx, 1);
    hs_write8(ctx, 0);

    /* extensions */
    if (total_ext) {
        hs_write16(ctx, total_ext);

        /* Secure Renegotiation */
        if (ext_reneg) {
            hs_write16(ctx, 0xFF01);
            uint32_t blob_len = ext_reneg - 4;
            hs_write16(ctx, blob_len);
            /* blob_len-1 바이트 데이터, 1바이트 길이 헤더 */
            hs_write_blob_head8(ctx,
                (uint32_t)offsetof(br_ssl_engine_context, saved_finished),
                blob_len - 1);
        }

        /* SNI */
        if (ext_sni) {
            uint32_t sni_len = hs_strlen(eng,
                offsetof(br_ssl_engine_context, server_name));
            hs_write16(ctx, 0x0000);
            hs_write16(ctx, ext_sni - 4);       /* extension length */
            hs_write16(ctx, ext_sni - 6);       /* ServerNameList length */
            hs_write8(ctx, 0);                  /* name type: host_name */
            hs_write_blob_head16(ctx,
                (uint32_t)offsetof(br_ssl_engine_context, server_name),
                sni_len);
        }

        /* Max Fragment Length */
        if (ext_frag) {
            hs_write16(ctx, 0x0001);
            hs_write16(ctx, 1);
            hs_write8(ctx, (unsigned char)(
                hs_get8(eng, offsetof(br_ssl_engine_context,
                    log_max_frag_len)) - 8));
        }

        /* Signature Algorithms */
        if (ext_sig) {
            hs_write16(ctx, 0x000D);
            hs_write16(ctx, ext_sig - 4);
            hs_write16(ctx, ext_sig - 6);
            if (hs_supports_ecdsa(eng)) hs_write_hashes(ctx, 3);
            if (hs_supports_rsa_sign(eng)) hs_write_hashes(ctx, 1);
        }

        /* Supported Curves: Curve25519(29) 우선, 나머지 ID 오름차순 */
        if (ext_curves) {
            uint32_t curves = hs_supported_curves(eng);
            hs_write16(ctx, 0x000A);
            hs_write16(ctx, ext_curves - 4);
            hs_write16(ctx, ext_curves - 6);
            if (curves & (1U << 29)) {
                curves &= ~(1U << 29);
                hs_write16(ctx, 29);
            }
            {
                int i;
                for (i = 0; i < 32; i++) {
                    if ((curves >> i) & 1) hs_write16(ctx, (uint32_t)i);
                }
            }
        }

        /* Point Formats: uncompressed only */
        if (ext_pts) {
            hs_write16(ctx, 0x000B);
            hs_write16(ctx, 2);
            hs_write16(ctx, 0x0100);  /* len=1, format=uncompressed */
        }

        /* ALPN */
        if (ext_alpn) {
            size_t u;
            hs_write16(ctx, 0x0010);
            hs_write16(ctx, (uint32_t)(ext_alpn - 4));
            hs_write16(ctx, (uint32_t)(ext_alpn - 6));
            for (u = 0; u < eng->protocol_names_num; u++) {
                size_t nlen = hs_copy_protocol_name(eng, u);
                hs_write8(ctx, (unsigned char)nlen);
                hs_write_blob(ctx,
                    (uint32_t)offsetof(br_ssl_engine_context, pad),
                    (uint32_t)nlen);
            }
        }

        /* Padding */
        if (ext_padding >= 0) {
            hs_write16(ctx, 0x0015);
            hs_write16(ctx, (uint32_t)ext_padding);
            {
                int i;
                for (i = 0; i < ext_padding; i++) hs_write8(ctx, 0);
            }
        }
    }
}

/* ======================================================================
 * 섹션 5: ServerHello 파싱
 * ====================================================================== */

/*
 * : check-resume ( val addr resume -- )
 *   if get16 = ifnot ERR_RESUME_MISMATCH fail then else set16 then ;
 *
 * resume != 0 이면 addr 필드값이 val과 같은지 검증.
 * resume == 0 이면 addr 필드에 val을 기록.
 */
static void
hs_check_resume(hs_run_ctx *ctx,
    uint32_t val, size_t addr, int resume)
{
    if (resume) {
        if (hs_get16(ctx->eng, (uint32_t)addr) != (uint16_t)val)
            hs_fail(ctx->eng, BR_ERR_RESUME_MISMATCH);
    } else {
        hs_set16(ctx->eng, (uint32_t)addr, (uint16_t)val);
    }
}

/*
 * : read-server-sni ( lim -- lim )
 *   read16 if ERR_BAD_SNI fail then ;
 *
 * 서버 SNI 응답 확장은 비어 있어야 한다(길이 0).
 */
static void
hs_read_server_sni(hs_run_ctx *ctx, uint32_t *lim)
{
    if (hs_read16(ctx, lim) != 0) hs_fail(ctx->eng, BR_ERR_BAD_SNI);
}

/*
 * : read-server-frag ( lim -- lim )
 *   read16 1 = ifnot ERR_BAD_FRAGLEN fail then
 *   read8 8 + addr-log_max_frag_len get8 = ifnot ERR_BAD_FRAGLEN fail then ;
 */
static void
hs_read_server_frag(hs_run_ctx *ctx, uint32_t *lim)
{
    br_ssl_engine_context *eng = ctx->eng;

    if (hs_read16(ctx, lim) != 1) hs_fail(eng, BR_ERR_BAD_FRAGLEN);
    int val = hs_read8(ctx, lim);
    if ((val + 8) != hs_get8(eng,
            offsetof(br_ssl_engine_context, log_max_frag_len)))
    {
        hs_fail(eng, BR_ERR_BAD_FRAGLEN);
    }
}

/*
 * : read-server-reneg ( lim -- lim )
 *
 * 최초 핸드셰이크(reneg==0): 서버 확장이 비어 있어야 함 → reneg=2로 갱신.
 * 재협상(reneg!=0): 24바이트로 client+server finished 검증.
 */
static void
hs_read_server_reneg(hs_run_ctx *ctx, uint32_t *lim)
{
    br_ssl_engine_context *eng = ctx->eng;

    uint32_t ext_len = hs_read16(ctx, lim);
    uint8_t  reneg   = hs_get8(eng, offsetof(br_ssl_engine_context, reneg));

    if (!reneg) {
        /* 최초 핸드셰이크: 길이 1, 데이터 0x00 */
        if (ext_len != 1) hs_fail(eng, BR_ERR_BAD_SECRENEG);
        if (hs_read8(ctx, lim) != 0) hs_fail(eng, BR_ERR_BAD_SECRENEG);
        hs_set8(eng, offsetof(br_ssl_engine_context, reneg), 2);
    } else {
        /* 재협상: 길이 25(헤더1 + client12 + server12), 헤더값 24 */
        if (ext_len != 25) hs_fail(eng, BR_ERR_BAD_SECRENEG);
        if (hs_read8(ctx, lim) != 24) hs_fail(eng, BR_ERR_BAD_SECRENEG);
        hs_read_blob(ctx, lim,
            (uint32_t)offsetof(br_ssl_engine_context, pad), 24);
        if (!hs_memcmp(eng,
                offsetof(br_ssl_engine_context, saved_finished),
                offsetof(br_ssl_engine_context, pad), 24))
        {
            hs_fail(eng, BR_ERR_BAD_SECRENEG);
        }
    }
}

/*
 * : read-ALPN-from-server ( lim -- lim )
 *
 * 서버가 선택한 프로토콜이 우리 목록에 있는지 확인하고 selected_protocol에 기록.
 * 없으면 flag 3이 설정된 경우에만 오류.
 */
static void
hs_read_ALPN_from_server(hs_run_ctx *ctx, uint32_t *lim)
{
    br_ssl_engine_context *eng = ctx->eng;

    uint32_t ext_outer, ext_inner;
    uint32_t ext_len = hs_read16(ctx, lim);
    hs_open_elt(ctx, *lim, ext_len, &ext_outer, &ext_inner);
    *lim = ext_outer;

    /* 프로토콜 이름 목록 (단 하나여야 함) */
    uint32_t list_outer, list_inner;
    uint32_t list_len = hs_read16(ctx, &ext_inner);
    hs_open_elt(ctx, ext_inner, list_len, &list_outer, &list_inner);
    ext_inner = list_outer;

    /* 단일 이름 읽기 */
    uint32_t name_len = (uint32_t)hs_read8(ctx, &list_inner);
    hs_read_blob(ctx, &list_inner,
        (uint32_t)offsetof(br_ssl_engine_context, pad), name_len);
    hs_close_elt(ctx, list_inner);
    hs_close_elt(ctx, ext_inner);

    int32_t idx = hs_test_protocol_name(eng, (size_t)name_len);
    if (idx < 0) {
        if (hs_flag(eng, 3)) hs_fail(eng, BR_ERR_UNEXPECTED);
    } else {
        hs_set16(eng, offsetof(br_ssl_engine_context, selected_protocol),
            (uint16_t)(idx + 1));
    }
}

/*
 * : read-ServerHello ( -- bool )
 *
 * ServerHello를 파싱한다. 세션 재개이면 -1, 아니면 0을 반환한다.
 */
static int
hs_read_ServerHello(hs_run_ctx *ctx)
{
    br_ssl_engine_context *eng = ctx->eng;
    uint32_t lim;
    int      type;

    hs_read_handshake_header(ctx, &lim, &type);
    if (type != 2) hs_fail(eng, BR_ERR_UNEXPECTED);

    /* 프로토콜 버전 */
    uint32_t version = hs_read16(ctx, &lim);
    uint16_t vmin = hs_get16(eng, offsetof(br_ssl_engine_context, version_min));
    uint16_t vmax = hs_get16(eng, offsetof(br_ssl_engine_context, version_max));
    if (version < vmin || version > vmax)
        hs_fail(eng, BR_ERR_UNSUPPORTED_VERSION);

    /* 이미 설정된 version_in과 일치해야 한다 */
    if ((uint16_t)version != hs_get16(eng,
            offsetof(br_ssl_engine_context, version_in)))
    {
        hs_fail(eng, BR_ERR_BAD_VERSION);
    }
    hs_set16(eng, offsetof(br_ssl_engine_context, version_out),
        (uint16_t)version);

    /* server random */
    hs_read_blob(ctx, &lim,
        (uint32_t)offsetof(br_ssl_engine_context, server_random), 32);

    /* session ID로 재개 여부 판단 */
    int resume = 0;
    uint32_t idlen = (uint32_t)hs_read8(ctx, &lim);
    if (idlen > 32) hs_fail(eng, BR_ERR_OVERSIZED_ID);
    hs_read_blob(ctx, &lim,
        (uint32_t)offsetof(br_ssl_engine_context, pad), idlen);

    uint8_t own_idlen = hs_get8(eng,
        offsetof(br_ssl_engine_context, session) +
        offsetof(br_ssl_session_parameters, session_id_len));
    if (idlen == own_idlen && idlen > 0) {
        if (hs_memcmp(eng,
                offsetof(br_ssl_engine_context, session) +
                offsetof(br_ssl_session_parameters, session_id),
                offsetof(br_ssl_engine_context, pad), idlen))
        {
            resume = -1;
        }
    }
    /* 서버 세션 ID를 저장 */
    hs_memcpy(eng,
        offsetof(br_ssl_engine_context, session) +
        offsetof(br_ssl_session_parameters, session_id),
        offsetof(br_ssl_engine_context, pad), idlen);
    hs_set8(eng,
        offsetof(br_ssl_engine_context, session) +
        offsetof(br_ssl_session_parameters, session_id_len),
        (uint8_t)idlen);

    /* 버전 재개 검증 또는 기록 */
    hs_check_resume(ctx, version,
        offsetof(br_ssl_engine_context, session) +
        offsetof(br_ssl_session_parameters, version), resume);

    /* cipher suite */
    uint32_t suite = hs_read16(ctx, &lim);
    if (hs_scan_suite(eng, (uint16_t)suite) < 0)
        hs_fail(eng, BR_ERR_BAD_CIPHER_SUITE);
    if (hs_use_tls12((uint16_t)suite) && version < 0x0303)
        hs_fail(eng, BR_ERR_BAD_CIPHER_SUITE);
    hs_check_resume(ctx, suite,
        offsetof(br_ssl_engine_context, session) +
        offsetof(br_ssl_session_parameters, cipher_suite), resume);

    /* compression: 0만 허용 */
    if (hs_read8(ctx, &lim) != 0) hs_fail(eng, BR_ERR_BAD_COMPRESSION);

    /* 확장 파싱 */
    if (lim > 0) {
        /* 우리가 보낸 확장 길이를 "허용 플래그"로 사용 */
        uint32_t ok_sni    = hs_ext_sni_length(eng);
        uint32_t ok_reneg  = hs_ext_reneg_length(eng);
        uint32_t ok_frag   = hs_ext_frag_length(eng);
        uint32_t ok_sig    = hs_ext_signatures_length(eng);
        uint32_t ok_curves = hs_ext_supported_curves_length(eng);
        uint32_t ok_pts    = hs_ext_point_format_length(eng);
        uint32_t ok_alpn   = hs_ext_ALPN_length(eng);

        uint32_t ext_list_len = hs_read16(ctx, &lim);
        uint32_t ext_outer, ext_inner;
        hs_open_elt(ctx, lim, ext_list_len, &ext_outer, &ext_inner);
        lim = ext_outer;

        while (ext_inner > 0) {
            uint32_t etype = hs_read16(ctx, &ext_inner);
            switch (etype) {
            case 0x0000:  /* SNI */
                if (!ok_sni) hs_fail(eng, BR_ERR_EXTRA_EXTENSION);
                ok_sni = 0;
                hs_read_server_sni(ctx, &ext_inner);
                break;
            case 0x0001:  /* Max Frag Length */
                if (!ok_frag) hs_fail(eng, BR_ERR_EXTRA_EXTENSION);
                ok_frag = 0;
                hs_read_server_frag(ctx, &ext_inner);
                break;
            case 0xFF01:  /* Secure Renegotiation */
                if (!ok_reneg) hs_fail(eng, BR_ERR_EXTRA_EXTENSION);
                ok_reneg = 0;
                hs_read_server_reneg(ctx, &ext_inner);
                break;
            case 0x000D:  /* Signature Algorithms (서버가 보내서는 안 되지만 허용) */
                if (!ok_sig) hs_fail(eng, BR_ERR_EXTRA_EXTENSION);
                ok_sig = 0;
                hs_read_ignore_16(ctx, &ext_inner);
                break;
            case 0x000A:  /* Supported Curves */
                if (!ok_curves) hs_fail(eng, BR_ERR_EXTRA_EXTENSION);
                ok_curves = 0;
                hs_read_ignore_16(ctx, &ext_inner);
                break;
            case 0x000B:  /* Point Formats */
                if (!ok_pts) hs_fail(eng, BR_ERR_EXTRA_EXTENSION);
                ok_pts = 0;
                hs_read_ignore_16(ctx, &ext_inner);
                break;
            case 0x0010:  /* ALPN */
                if (!ok_alpn) hs_fail(eng, BR_ERR_EXTRA_EXTENSION);
                ok_alpn = 0;
                hs_read_ALPN_from_server(ctx, &ext_inner);
                break;
            default:
                hs_fail(eng, BR_ERR_EXTRA_EXTENSION);
                break;
            }
        }
        hs_close_elt(ctx, ext_inner);

        /* reneg 확장을 보냈는데 응답이 없으면: 재협상이면 오류 */
        if (ok_reneg) {
            if (ok_reneg > 5) hs_fail(eng, BR_ERR_BAD_SECRENEG);
            hs_set8(eng, offsetof(br_ssl_engine_context, reneg), 1);
        }
    } else {
        /* 확장 없음: reneg를 보냈는데 응답 없음 */
        if (hs_ext_reneg_length(eng) > 5) hs_fail(eng, BR_ERR_BAD_SECRENEG);
        hs_set8(eng, offsetof(br_ssl_engine_context, reneg), 1);
    }

    hs_close_elt(ctx, lim);
    return resume;
}

/* ======================================================================
 * 섹션 6: ServerKeyExchange 파싱
 * ====================================================================== */

/*
 * : read-ServerKeyExchange ( -- )
 *
 * ECDHE용 ServerKeyExchange를 파싱하고 서버 서명을 검증한다.
 */
static void
hs_read_ServerKeyExchange(hs_run_ctx *ctx)
{
    br_ssl_engine_context *eng = ctx->eng;
    uint32_t lim;
    int      type;

    hs_read_handshake_header(ctx, &lim, &type);
    if (type != 12) hs_fail(eng, BR_ERR_UNEXPECTED);

    /* named_curve 형식이어야 한다(curve_type == 3) */
    if (hs_read8(ctx, &lim) != 3) hs_fail(eng, BR_ERR_INVALID_ALGORITHM);

    /* curve_id */
    uint32_t curve_id = hs_read16(ctx, &lim);
    hs_set8(eng, offsetof(br_ssl_engine_context, ecdhe_curve),
        (uint8_t)curve_id);
    if (curve_id >= 32) hs_fail(eng, BR_ERR_INVALID_ALGORITHM);
    if (!((hs_supported_curves(eng) >> curve_id) & 1))
        hs_fail(eng, BR_ERR_INVALID_ALGORITHM);

    /* 서버 공개 포인트 */
    uint32_t pt_len = (uint32_t)hs_read8(ctx, &lim);
    if (pt_len > 133) hs_fail(eng, BR_ERR_INVALID_ALGORITHM);
    hs_set8(eng, offsetof(br_ssl_engine_context, ecdhe_point_len),
        (uint8_t)pt_len);
    hs_read_blob(ctx, &lim,
        (uint32_t)offsetof(br_ssl_engine_context, ecdhe_point), pt_len);

    /* 서명 알고리즘 처리 */
    int tls12   = (hs_get16(eng, offsetof(br_ssl_engine_context, version_in))
                   >= 0x0303);
    uint16_t suite = hs_get16(eng,
        offsetof(br_ssl_engine_context, session) +
        offsetof(br_ssl_session_parameters, cipher_suite));
    int use_rsa = hs_use_rsa_ecdhe(suite) ? -1 : 0;
    int hash    = 2;   /* 기본: SHA-1 */

    if (tls12) {
        /* 명시적 hash + sig 알고리즘 */
        hash = hs_read8(ctx, &lim);
        if (hash < 2 || hash > 6) hs_fail(eng, BR_ERR_INVALID_ALGORITHM);

        int sa = hs_read8(ctx, &lim);
        /* use_rsa==-1→wire:1, use_rsa==0→wire:3 */
        int expected_sa = use_rsa ? 1 : 3;
        if (sa != expected_sa) hs_fail(eng, BR_ERR_INVALID_ALGORITHM);
    } else {
        /* TLS 1.0/1.1: RSA이면 MD5+SHA-1(0), ECDSA이면 SHA-1(2) */
        if (use_rsa) hash = 0;
    }

    /* 서명 읽기 */
    uint32_t sig_len = hs_read16(ctx, &lim);
    if (sig_len > 512) hs_fail(eng, BR_ERR_LIMIT_EXCEEDED);
    hs_read_blob(ctx, &lim,
        (uint32_t)offsetof(br_ssl_engine_context, pad), sig_len);

    /* 서명 검증 */
    int err = hs_verify_SKE_sig(ctx, hash, use_rsa, (size_t)sig_len);
    if (err) hs_fail(eng, err);

    hs_close_elt(ctx, lim);
}

/* ======================================================================
 * 섹션 7: CertificateRequest 파싱
 * ====================================================================== */

/*
 * : read-Certificate-from-server ( -- )
 *
 * 서버 인증서를 읽고 키 타입을 cipher suite와 대조한다.
 */
static void
hs_read_Certificate_from_server(hs_run_ctx *ctx)
{
    br_ssl_engine_context *eng = ctx->eng;
    uint32_t expected_kt = hs_expected_key_type(
        hs_get16(eng,
            offsetof(br_ssl_engine_context, session) +
            offsetof(br_ssl_session_parameters, cipher_suite)));

    uint32_t ktu = hs_read_Certificate(ctx, -1);

    if ((int32_t)ktu < 0) hs_fail(eng, (int)(-(int32_t)ktu));
    if (!ktu) hs_fail(eng, BR_ERR_UNEXPECTED);
    if ((ktu & expected_kt) != expected_kt) hs_fail(eng, BR_ERR_WRONG_KEY_USAGE);

    hs_set_server_curve(ctx);
}

/*
 * : read-contents-CertificateRequest ( lim -- )
 *
 * CertificateRequest 본문을 파싱한다.
 * 지원하는 인증 타입, sign+hash 목록, 신뢰 앵커 DN 목록을 처리하고
 * get-client-chain을 호출한다.
 */
static void
hs_read_contents_CertificateRequest(hs_run_ctx *ctx, uint32_t lim)
{
    br_ssl_engine_context *eng = ctx->eng;

    /* 인증 타입 목록 */
    uint32_t auth_types = 0;
    uint32_t at_len = (uint32_t)hs_read8(ctx, &lim);
    uint32_t at_outer, at_inner;
    hs_open_elt(ctx, lim, at_len, &at_outer, &at_inner);
    lim = at_outer;

    while (at_inner > 0) {
        int at = hs_read8(ctx, &at_inner);
        switch (at) {
        case  1: auth_types |= 0x0000FF; break;  /* rsa_sign */
        case 64: auth_types |= 0x00FF00; break;  /* ecdsa_sign */
        case 65: auth_types |= 0x010000; break;  /* rsa_fixed_ecdh */
        case 66: auth_types |= 0x020000; break;  /* ecdsa_fixed_ecdh */
        }
    }
    hs_close_elt(ctx, at_inner);

    /* ECDH 스위트가 아니면 정적 ECDH 비트 제거 */
    uint16_t suite = hs_get16(eng,
        offsetof(br_ssl_engine_context, session) +
        offsetof(br_ssl_session_parameters, cipher_suite));
    if (!hs_use_ecdh(suite)) {
        auth_types &= 0x0000FFFF;
    }

    /* TLS 버전별 sign+hash 처리 */
    if (hs_get16(eng, offsetof(br_ssl_engine_context, version_in))
            >= 0x0303)
    {
        /* TLS 1.2: 명시적 sign+hash 목록 읽기 */
        uint32_t hashes = hs_read_list_sign_algos(ctx, &lim);
        hs_set32(eng, (uint32_t)OFF_CLI_hashes, hashes);

        /* 엔진이 지원하는 해시로 필터링 */
        uint32_t hx, dummy;
        hs_supported_hash_functions(eng, &hx, &dummy);
        hashes &= (hx | (hx << 8)) | 0x030000U;
        auth_types &= hashes;

        /* ECDH 플래그: 해당 서명 방법이 지원되면 설정 */
        if (auth_types & 0x030000) {
            if (auth_types & 0x0000FF) auth_types |= 0x010000;
            if (auth_types & 0x00FF00) auth_types |= 0x020000;
        }
    } else {
        /* TLS 1.0/1.1: 고정 알고리즘 (MD5+SHA-1/RSA, SHA-1/ECDSA) */
        auth_types &= 0x030401;
    }

    /* 신뢰 앵커 DN 목록 */
    hs_anchor_dn_start_name_list(ctx);
    uint32_t dn_list_len = hs_read16(ctx, &lim);
    uint32_t dn_outer, dn_inner;
    hs_open_elt(ctx, lim, dn_list_len, &dn_outer, &dn_inner);
    lim = dn_outer;

    while (dn_inner > 0) {
        uint32_t dn_len = hs_read16(ctx, &dn_inner);
        uint32_t name_outer, name_inner;
        hs_open_elt(ctx, dn_inner, dn_len, &name_outer, &name_inner);
        dn_inner = name_outer;

        hs_anchor_dn_start_name(ctx, (size_t)dn_len);
        while (name_inner > 0) {
            uint32_t chunk = name_inner > 256 ? 256 : name_inner;
            hs_read_blob(ctx, &name_inner,
                (uint32_t)offsetof(br_ssl_engine_context, pad), chunk);
            hs_anchor_dn_append_name(ctx, (size_t)chunk);
        }
        hs_close_elt(ctx, name_inner);
        hs_anchor_dn_end_name(ctx);
    }
    hs_close_elt(ctx, dn_inner);
    hs_anchor_dn_end_name_list(ctx);

    hs_close_elt(ctx, lim);

    /* 클라이언트 인증서 체인 획득 */
    hs_get_client_chain(ctx, auth_types);
}

/* ======================================================================
 * 섹션 8: ClientKeyExchange / CertificateVerify 작성
 * ====================================================================== */

/*
 * : write-ClientKeyExchange ( -- )
 *
 * RSA: 2바이트 길이 + 암호화된 PMS
 * ECDH/ECDHE: 1바이트 길이 + EC 포인트
 */
static void
hs_write_ClientKeyExchange(hs_run_ctx *ctx)
{
    br_ssl_engine_context *eng = ctx->eng;
    uint16_t suite = hs_get16(eng,
        offsetof(br_ssl_engine_context, session) +
        offsetof(br_ssl_session_parameters, cipher_suite));

    hs_write8(ctx, 16);  /* ClientKeyExchange type */

    if (hs_use_rsa_keyx(suite)) {
        int nlen = hs_do_rsa_encrypt(ctx, hs_prf_id(suite));
        hs_write24(ctx, (uint32_t)(nlen + 2));
        hs_write16(ctx, (uint32_t)nlen);
        hs_write_blob(ctx,
            (uint32_t)offsetof(br_ssl_engine_context, pad),
            (uint32_t)nlen);
    } else {
        /* ECDH 또는 ECDHE */
        int ecdhe = hs_use_ecdhe(suite) ? 1 : 0;
        int ulen  = hs_do_ecdh_client(ctx, (unsigned)ecdhe, hs_prf_id(suite));
        hs_write24(ctx, (uint32_t)(ulen + 1));
        hs_write8(ctx, (unsigned char)ulen);
        hs_write_blob(ctx,
            (uint32_t)offsetof(br_ssl_engine_context, pad),
            (uint32_t)ulen);
    }
}

/*
 * : write-CertificateVerify ( -- )
 *
 * 클라이언트 서명을 계산하고 CertificateVerify 메시지를 전송한다.
 */
static void
hs_write_CertificateVerify(hs_run_ctx *ctx)
{
    br_ssl_engine_context *eng = ctx->eng;
    size_t sig_len = hs_do_client_sign(ctx);

    hs_write8(ctx, 15);  /* CertificateVerify type */

    int tls12 = (hs_get16(eng,
        offsetof(br_ssl_engine_context, version_out)) >= 0x0303);

    if (tls12) {
        hs_write24(ctx, (uint32_t)(sig_len + 4));
        hs_write8(ctx, hs_get8(eng, (uint32_t)OFF_CLI_hash_id));
        hs_write8(ctx, hs_get8(eng, (uint32_t)OFF_CLI_auth_type));
    } else {
        hs_write24(ctx, (uint32_t)(sig_len + 2));
    }
    hs_write16(ctx, (uint32_t)sig_len);
    hs_write_blob(ctx,
        (uint32_t)offsetof(br_ssl_engine_context, pad),
        (uint32_t)sig_len);
}

/* ======================================================================
 * 섹션 9: 메인 코루틴
 * ====================================================================== */

/*
 * : read-HelloRequest ( -- )
 *   read-handshake-header-core
 *   if ERR_UNEXPECTED fail then      ← lim != 0
 *   if ERR_BAD_HANDSHAKE fail then ; ← type != 0
 */
static void
hs_read_HelloRequest(hs_run_ctx *ctx)
{
    br_ssl_engine_context *eng = ctx->eng;
    uint32_t lim;
    int      type;

    hs_read_handshake_header_core(ctx, &lim, &type);
    if (lim  != 0) hs_fail(eng, BR_ERR_UNEXPECTED);
    if (type != 0) hs_fail(eng, BR_ERR_BAD_HANDSHAKE);
}

/*
 * : do-handshake ( -- )
 *
 * TLS 클라이언트 핸드셰이크 전체 흐름.
 */
static void
hs_do_handshake_client(hs_run_ctx *ctx)
{
    br_ssl_engine_context *eng = ctx->eng;

    hs_set8(eng, offsetof(br_ssl_engine_context, application_data), 0);
    hs_set8(eng, offsetof(br_ssl_engine_context, record_type_out), 22);
    hs_set16(eng, offsetof(br_ssl_engine_context, selected_protocol), 0);
    hs_multihash_init(eng);

    hs_write_ClientHello(ctx);
    hs_flush_record(eng);

    int resume = hs_read_ServerHello(ctx);

    if (resume) {
        /* 세션 재개 */
        hs_read_CCS_Finished(ctx, -1);
        hs_write_CCS_Finished(ctx, -1);
    } else {
        /* 신규 핸드셰이크 */
        hs_read_Certificate_from_server(ctx);

        /* SIGN 키 타입이면 ServerKeyExchange 읽기 */
        uint16_t suite = hs_get16(eng,
            offsetof(br_ssl_engine_context, session) +
            offsetof(br_ssl_session_parameters, cipher_suite));
        if (hs_expected_key_type(suite) & BR_KEYTYPE_SIGN) {
            hs_read_ServerKeyExchange(ctx);
        }

        /* 다음 핸드셰이크 헤더 읽기 */
        uint32_t lim;
        int      htype;
        hs_read_handshake_header(ctx, &lim, &htype);

        /* CertificateRequest 처리 */
        int seen_CR = 0;
        if (htype == 13) {
            hs_read_contents_CertificateRequest(ctx, lim);
            hs_read_handshake_header(ctx, &lim, &htype);
            seen_CR = -1;
        }

        /* ServerHelloDone 확인 */
        if (htype != 14) hs_fail(eng, BR_ERR_UNEXPECTED);
        if (lim   != 0)  hs_fail(eng, BR_ERR_BAD_HELLO_DONE);
        if (hs_more_incoming_bytes(eng)) hs_fail(eng, BR_ERR_UNEXPECTED);

        if (seen_CR) {
            /* Certificate 메시지 전송 (빈 체인일 수도 있음) */
            hs_write_Certificate(ctx);

            uint8_t hid = hs_get8(eng, (uint32_t)OFF_CLI_hash_id);
            if (hid == 0xFF) {
                /*
                 * 정적 ECDH: ClientKeyExchange는 비어 있고
                 * CertificateVerify 없음
                 */
                hs_write8(ctx, 16);
                hs_write24(ctx, 0);
                hs_do_static_ecdh_client(ctx, hs_prf_id(suite));
            } else {
                hs_write_ClientKeyExchange(ctx);
                /* 인증서를 실제로 보낸 경우에만 CertificateVerify */
                if (eng->chain_len > 0)
                    hs_write_CertificateVerify(ctx);
            }
        } else {
            hs_write_ClientKeyExchange(ctx);
        }

        hs_write_CCS_Finished(ctx, -1);
        hs_read_CCS_Finished(ctx, -1);
    }

    hs_set8(eng, offsetof(br_ssl_engine_context, application_data), 1);
    hs_set8(eng, offsetof(br_ssl_engine_context, record_type_out), 23);
}

/*
 * : main ( -- ! )
 *
 * TLS 클라이언트 핸드셰이크 코루틴의 진입점.
 */
static void
hs_client_main(hs_run_ctx *ctx)
{
    br_ssl_engine_context *eng = ctx->eng;

    hs_do_handshake_client(ctx);

    for (;;) {
        int state = hs_wait_co(ctx);
        int low3  = state & 0x07;

        switch (low3) {
        case 0x00:
            /* 재협상 요청 */
            if (state & 0x10) {
                hs_do_handshake_client(ctx);
            }
            break;

        case 0x01:
            /* 서버 측 HelloRequest 수신 */
            hs_set8(eng, offsetof(br_ssl_engine_context,
                application_data), 0);
            hs_read_HelloRequest(ctx);

            if (hs_get8(eng, offsetof(br_ssl_engine_context, reneg)) == 1
                || hs_flag(eng, 1))
            {
                /* 재협상 거부: no_renegotiation(100) 경고 */
                hs_flush_record(eng);
                while (!hs_can_output(eng)) hs_wait_co(ctx);
                hs_send_warning(ctx, 100);
                hs_set8(eng, offsetof(br_ssl_engine_context,
                    application_data), 1);
                hs_set8(eng, offsetof(br_ssl_engine_context,
                    record_type_out), 23);
            } else {
                hs_do_handshake_client(ctx);
            }
            break;

        default:
            hs_fail(eng, BR_ERR_UNEXPECTED);
            break;
        }
    }
}

/*
 * hs_client_run() — 외부 엔진 루프에서 호출하는 진입점
 */
static void
hs_client_run(hs_run_ctx *ctx)
{
    if (!ctx->started) {
        ctx->started = 1;
        if (setjmp(ctx->caller_point) == 0) {
            hs_client_main(ctx);
        }
    } else {
        hs_resume(ctx);
    }
}

#endif /* SSL_HS_CLIENT_T0_H */
