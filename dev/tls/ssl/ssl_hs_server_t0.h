/*
 * ssl_hs_server_t0.h
 *
 * ssl_hs_server.t0의 모든 T0 단어와 cc: 단어를 C로 변환한 파일.
 *
 * 파일 구성
 * ---------
 *  1. server cc: 래퍼 함수들  (CTX를 사용하는 cc: 단어들)
 *  2. addr-ctx: 오프셋 매크로
 *  3. 확장 파싱 함수들        (read-client-sni, read-client-frag, ...)
 *  4. 핸드셰이크 쓰기 함수들  (write-ServerHello, write-ServerKeyExchange, ...)
 *  5. 핸드셰이크 읽기 함수들  (read-ClientHello, read-ClientKeyExchange, ...)
 *  6. 메인 코루틴             (do-handshake, main)
 *
 * 의존성
 * ------
 *  ssl_hs_common_t0.h  (3단계: hs_run_ctx, 공통 T0 단어들)
 */

#ifndef SSL_HS_SERVER_T0_H
#define SSL_HS_SERVER_T0_H

#include "ssl_hs_common_t0.h"

/* ======================================================================
 * CTX 파생 헬퍼
 *
 * T0 원문에서 ENG 매크로는 엔진 컨텍스트이고,
 * CTX 매크로는 서버 컨텍스트((br_ssl_server_context *)ENG)이다.
 * br_ssl_server_context.eng 가 첫 번째 필드이므로 캐스트로 변환 가능하다.
 * ====================================================================== */
static inline br_ssl_server_context *
hs_sctx(hs_run_ctx *ctx)
{
    return (br_ssl_server_context *)ctx->eng;
}

/* ======================================================================
 * 섹션 1: server cc: 래퍼 함수들
 *
 * ssl_hs_server.t0의 preamble C 함수들(do_rsa_decrypt, do_ecdh 등)은
 * 이미 순수 C이므로 그대로 사용한다.
 * cc: 단어들은 그 함수들을 호출하는 얇은 래퍼다.
 * ====================================================================== */

/*
 * cc: set-max-frag-len ( len -- )
 *
 * T0 원문:
 *   br_ssl_engine_new_max_frag_len(ENG, max_frag_len);
 *   if (ENG->hlen_out > max_frag_len) ENG->hlen_out = max_frag_len;
 */
static inline void
hs_set_max_frag_len(hs_run_ctx *ctx, size_t max_frag_len)
{
    br_ssl_engine_context *eng = ctx->eng;
    br_ssl_engine_new_max_frag_len(eng, max_frag_len);
    if (eng->hlen_out > max_frag_len) {
        eng->hlen_out = max_frag_len;
    }
}

/*
 * cc: call-policy-handler ( -- bool )
 *
 * T0 원문:
 *   x = (*CTX->policy_vtable)->choose(CTX->policy_vtable, CTX, &choices);
 *   ENG->session.cipher_suite = choices.cipher_suite;
 *   CTX->sign_hash_id          = choices.algo_id;
 *   ENG->chain                 = choices.chain;
 *   ENG->chain_len             = choices.chain_len;
 *   T0_PUSHi(-(x != 0));
 */
static inline int
hs_call_policy_handler(hs_run_ctx *ctx)
{
    br_ssl_server_context *sctx = hs_sctx(ctx);
    br_ssl_engine_context *eng  = ctx->eng;
    br_ssl_server_choices  choices;
    int x;

    x = (*sctx->policy_vtable)->choose(
        sctx->policy_vtable, sctx, &choices);
    eng->session.cipher_suite = choices.cipher_suite;
    sctx->sign_hash_id         = choices.algo_id;
    eng->chain                 = choices.chain;
    eng->chain_len             = choices.chain_len;
    return x ? -1 : 0;
}

/*
 * cc: check-resume ( -- bool )
 *
 * T0 원문:
 *   if (ENG->session.session_id_len == 32
 *       && CTX->cache_vtable != NULL
 *       && (*CTX->cache_vtable)->load(...))
 *   { T0_PUSHi(-1); } else { T0_PUSH(0); }
 */
static inline int
hs_check_resume(hs_run_ctx *ctx)
{
    br_ssl_server_context *sctx = hs_sctx(ctx);
    br_ssl_engine_context *eng  = ctx->eng;

    if (eng->session.session_id_len == 32
        && sctx->cache_vtable != NULL
        && (*sctx->cache_vtable)->load(
               sctx->cache_vtable, sctx, &eng->session))
    {
        return -1;
    }
    return 0;
}

/*
 * cc: save-session ( -- )
 */
static inline void
hs_save_session(hs_run_ctx *ctx)
{
    br_ssl_server_context *sctx = hs_sctx(ctx);
    if (sctx->cache_vtable != NULL) {
        (*sctx->cache_vtable)->save(
            sctx->cache_vtable, sctx, &ctx->eng->session);
    }
}

/*
 * cc: do-ecdhe-part1 ( curve -- len )
 *
 * T0 원문:
 *   T0_PUSHi(do_ecdhe_part1(CTX, curve));
 */
static inline int
hs_do_ecdhe_part1(hs_run_ctx *ctx, int curve)
{
    return do_ecdhe_part1(hs_sctx(ctx), curve);
}

/*
 * cc: ta-names-total-length ( -- len )
 *
 * 클라이언트 인증 요청 시 보낼 신뢰 앵커 DN 목록의 총 바이트 길이.
 * ta_names가 있으면 그것을, 없으면 tas[].dn을 사용한다.
 */
static inline size_t
hs_ta_names_total_length(hs_run_ctx *ctx)
{
    br_ssl_server_context *sctx = hs_sctx(ctx);
    size_t u, len = 0;

    if (sctx->ta_names != NULL) {
        for (u = 0; u < sctx->num_tas; u++) {
            len += sctx->ta_names[u].len + 2;
        }
    } else if (sctx->tas != NULL) {
        for (u = 0; u < sctx->num_tas; u++) {
            len += sctx->tas[u].dn.len + 2;
        }
    }
    return len;
}

/*
 * cc: begin-ta-name-list ( -- )
 */
static inline void
hs_begin_ta_name_list(hs_run_ctx *ctx)
{
    hs_sctx(ctx)->cur_dn_index = 0;
}

/*
 * cc: begin-ta-name ( -- len )
 *
 * 반환값이 -1이면 목록 끝이다.
 */
static inline int32_t
hs_begin_ta_name(hs_run_ctx *ctx)
{
    br_ssl_server_context *sctx = hs_sctx(ctx);
    const br_x500_name    *dn;

    if (sctx->cur_dn_index >= sctx->num_tas) return -1;

    if (sctx->ta_names == NULL) {
        dn = &sctx->tas[sctx->cur_dn_index].dn;
    } else {
        dn = &sctx->ta_names[sctx->cur_dn_index];
    }
    sctx->cur_dn_index++;
    sctx->cur_dn     = dn->data;
    sctx->cur_dn_len = dn->len;
    return (int32_t)sctx->cur_dn_len;
}

/*
 * cc: copy-dn-chunk ( -- len )
 *
 * 현재 DN 데이터를 pad 크기 단위로 복사한다. 0이면 완료.
 */
static inline size_t
hs_copy_dn_chunk(hs_run_ctx *ctx)
{
    br_ssl_server_context *sctx = hs_sctx(ctx);
    br_ssl_engine_context *eng  = ctx->eng;
    size_t clen = sctx->cur_dn_len;

    if (clen > sizeof eng->pad) clen = sizeof eng->pad;
    memcpy(eng->pad, sctx->cur_dn, clen);
    sctx->cur_dn     += clen;
    sctx->cur_dn_len -= clen;
    return clen;
}

/*
 * cc: do-rsa-decrypt ( len prf_id -- )
 */
static inline void
hs_do_rsa_decrypt(hs_run_ctx *ctx, size_t len, int prf_id)
{
    do_rsa_decrypt(hs_sctx(ctx), prf_id, ctx->eng->pad, len);
}

/*
 * cc: do-ecdh ( len prf_id -- )
 */
static inline void
hs_do_ecdh(hs_run_ctx *ctx, size_t len, int prf_id)
{
    do_ecdh(hs_sctx(ctx), prf_id, ctx->eng->pad, len);
}

/*
 * cc: do-ecdhe-part2 ( len prf_id -- )
 */
static inline void
hs_do_ecdhe_part2(hs_run_ctx *ctx, size_t len, int prf_id)
{
    do_ecdhe_part2(hs_sctx(ctx), prf_id, ctx->eng->pad, len);
}

/*
 * cc: do-static-ecdh ( prf_id -- )
 */
static inline void
hs_do_static_ecdh(hs_run_ctx *ctx, int prf_id)
{
    do_static_ecdh(hs_sctx(ctx), prf_id);
}

/*
 * cc: compute-hash-CV ( -- )
 *
 * 현재까지의 핸드셰이크 데이터를 MD5~SHA-512 6개 해시로 계산해 pad에 저장.
 */
static inline void
hs_compute_hash_CV(hs_run_ctx *ctx)
{
    br_ssl_engine_context *eng = ctx->eng;
    int i;
    for (i = 1; i <= 6; i++) {
        br_multihash_out(&eng->mhash, i,
            eng->pad + HASH_PAD_OFF[i - 1]);
    }
}

/*
 * cc: copy-hash-CV ( hash_id -- bool )
 *
 * pad에서 적절한 해시값을 hash_CV 버퍼로 복사한다.
 * hash_id == 0 이면 MD5+SHA-1(36바이트).
 */
static inline int
hs_copy_hash_CV(hs_run_ctx *ctx, int id)
{
    br_ssl_server_context *sctx = hs_sctx(ctx);
    br_ssl_engine_context *eng  = ctx->eng;
    size_t off, len;

    if (id == 0) {
        off = 0;
        len = 36;
    } else {
        if (br_multihash_getimpl(&eng->mhash, id) == 0) return 0;
        off = HASH_PAD_OFF[id - 1];
        len = HASH_PAD_OFF[id] - off;
    }
    memcpy(sctx->hash_CV, eng->pad + off, len);
    sctx->hash_CV_len = len;
    sctx->hash_CV_id  = id;
    return -1;
}

/*
 * cc: verify-CV-sig ( sig-len -- err )
 */
static inline int
hs_verify_CV_sig(hs_run_ctx *ctx, size_t sig_len)
{
    return verify_CV_sig(hs_sctx(ctx), sig_len);
}

/* ======================================================================
 * 섹션 2: addr-ctx: 오프셋 매크로
 *
 * T0 원문:
 *   addr-ctx: client_max_version
 *   → addr-client_max_version 단어가 offsetof(br_ssl_server_context, ...) 를 push
 *
 * C에서는 offsetof 매크로로 직접 사용한다.
 * ====================================================================== */

#define OFF_CTX_client_max_version  offsetof(br_ssl_server_context, client_max_version)
#define OFF_CTX_client_suites       offsetof(br_ssl_server_context, client_suites)
#define OFF_CTX_client_suites_num   offsetof(br_ssl_server_context, client_suites_num)
#define OFF_CTX_hashes              offsetof(br_ssl_server_context, hashes)
#define OFF_CTX_curves              offsetof(br_ssl_server_context, curves)
#define OFF_CTX_sign_hash_id        offsetof(br_ssl_server_context, sign_hash_id)

/*
 * : addr-len-client_suites ( -- addr len )
 *   addr-client_suites
 *   CX 0 1023 { BR_MAX_CIPHER_SUITES * sizeof(br_suite_translated) } ;
 *
 * client_suites 버퍼의 오프셋과 최대 바이트 크기를 반환한다.
 * 값은 br_ssl_server_context 오프셋 기준이므로,
 * eng_get/set은 br_ssl_engine_context 오프셋을 기대한다.
 * 서버 컨텍스트에서는 eng가 첫 필드이므로 오프셋이 동일하다.
 */
static inline void
hs_addr_len_client_suites(uint32_t *out_addr, uint32_t *out_len)
{
    *out_addr = (uint32_t)OFF_CTX_client_suites;
    *out_len  = (uint32_t)(BR_MAX_CIPHER_SUITES * sizeof(br_suite_translated));
}

/* ======================================================================
 * 섹션 3: 확장 파싱 함수들
 * ====================================================================== */

/*
 * : read-client-sni ( lim -- lim )
 *
 * SNI 확장을 파싱해 server_name 필드에 기록한다.
 * host_name 타입(0)이고 255바이트 이하인 첫 번째 이름을 사용한다.
 */
static void
hs_read_client_sni(hs_run_ctx *ctx, uint32_t *lim)
{
    br_ssl_engine_context *eng = ctx->eng;
    uint32_t ext_len, ext_outer, ext_inner;
    uint32_t list_outer, list_inner;

    /* 확장 값 열기 */
    ext_len = hs_read16(ctx, lim);
    hs_open_elt(ctx, *lim, ext_len, &ext_outer, &ext_inner);
    *lim = ext_outer;

    /* ServerNameList 열기 */
    uint32_t sn_len = hs_read16(ctx, &ext_inner);
    hs_open_elt(ctx, ext_inner, sn_len, &list_outer, &list_inner);
    ext_inner = list_outer;

    while (list_inner > 0) {
        int name_type = hs_read8(ctx, &list_inner);
        if (name_type != 0) {
            /* 알 수 없는 타입: 건너뜀 */
            hs_read_ignore_16(ctx, &list_inner);
        } else {
            uint32_t name_len = hs_read16(ctx, &list_inner);
            if (name_len <= 255) {
                /* NUL 종료 후 복사 */
                *((unsigned char *)eng + offsetof(br_ssl_engine_context,
                    server_name) + name_len) = '\0';
                hs_read_blob(ctx, &list_inner,
                    (uint32_t)offsetof(br_ssl_engine_context, server_name),
                    name_len);
            } else {
                hs_skip_blob(ctx, &list_inner, name_len);
            }
        }
    }

    hs_close_elt(ctx, list_inner);
    hs_close_elt(ctx, ext_inner);
}

/*
 * : read-client-frag ( lim -- lim )
 *
 * Max Fragment Length 확장(RFC 6066). 값은 정확히 1바이트(1~4).
 */
static void
hs_read_client_frag(hs_run_ctx *ctx, uint32_t *lim)
{
    br_ssl_engine_context *eng = ctx->eng;

    uint32_t ext_len = hs_read16(ctx, lim);
    if (ext_len != 1) hs_fail(eng, BR_ERR_BAD_FRAGLEN);

    int val = hs_read8(ctx, lim);  /* lim은 이미 ext 경계 반영됨 — 하지만 여기선 외부 lim */

    /* val은 1~4 사이여야 한다 */
    if (val == 0 || val >= 5) hs_fail(eng, BR_ERR_BAD_FRAGLEN);

    /*
     * log_max_frag_len 과 비교해 더 작은 쪽을 적용한다.
     * 확장에서 온 값은 val+8 (즉 9~12 = 512~4096 바이트의 log2).
     */
    int log_peer = val + 8;
    uint8_t log_own = hs_get8(eng,
        offsetof(br_ssl_engine_context, log_max_frag_len));

    if ((uint8_t)log_peer < log_own) {
        size_t max_frag = (size_t)1 << log_peer;
        hs_set_max_frag_len(ctx, max_frag);
        hs_set8(eng, offsetof(br_ssl_engine_context, log_max_frag_len),
            (uint8_t)log_peer);
        hs_set8(eng, offsetof(br_ssl_engine_context, peer_log_max_frag_len),
            (uint8_t)log_peer);
    }
}

/*
 * : read-client-reneg ( lim -- lim )
 *
 * Secure Renegotiation 확장(RFC 5746).
 */
static void
hs_read_client_reneg(hs_run_ctx *ctx, uint32_t *lim)
{
    br_ssl_engine_context *eng = ctx->eng;

    uint32_t val_len = hs_read16(ctx, lim);
    uint8_t  reneg   = hs_get8(eng, offsetof(br_ssl_engine_context, reneg));

    switch (reneg) {
    case 0:
        /* 첫 핸드셰이크: 값 길이는 정확히 1, 내용은 0(empty) */
        if (val_len != 1) hs_fail(eng, BR_ERR_BAD_SECRENEG);
        if (hs_read8(ctx, lim) != 0) hs_fail(eng, BR_ERR_BAD_SECRENEG);
        hs_set8(eng, offsetof(br_ssl_engine_context, reneg), 2);
        break;

    case 2:
        /* 재협상: 길이는 13(헤더 1 + saved client finished 12) */
        if (val_len != 13) hs_fail(eng, BR_ERR_BAD_SECRENEG);
        if (hs_read8(ctx, lim) != 12) hs_fail(eng, BR_ERR_BAD_SECRENEG);
        hs_read_blob(ctx, lim,
            (uint32_t)offsetof(br_ssl_engine_context, pad), 12);
        if (!hs_memcmp(eng,
                offsetof(br_ssl_engine_context, saved_finished),
                offsetof(br_ssl_engine_context, pad), 12))
        {
            hs_fail(eng, BR_ERR_BAD_SECRENEG);
        }
        break;

    default:
        /* reneg==1: 클라이언트가 지원 안 한다고 했는데 확장을 보냄 → 이상 */
        hs_fail(eng, BR_ERR_BAD_SECRENEG);
        break;
    }
}

/*
 * : read-signatures ( lim -- lim )
 *
 * Signature Algorithms 확장(RFC 5246 §7.4.1.4.1).
 */
static void
hs_read_signatures(hs_run_ctx *ctx, uint32_t *lim)
{
    uint32_t ext_len = hs_read16(ctx, lim);
    uint32_t ext_outer, ext_inner;
    hs_open_elt(ctx, *lim, ext_len, &ext_outer, &ext_inner);
    *lim = ext_outer;

    uint32_t hashes = hs_read_list_sign_algos(ctx, &ext_inner);
    hs_set32(ctx->eng, (uint32_t)OFF_CTX_hashes, hashes);

    hs_close_elt(ctx, ext_inner);
}

/*
 * : read-supported-curves ( lim -- lim )
 *
 * Supported Elliptic Curves 확장(RFC 4492).
 */
static void
hs_read_supported_curves(hs_run_ctx *ctx, uint32_t *lim)
{
    br_ssl_engine_context *eng = ctx->eng;

    uint32_t ext_len = hs_read16(ctx, lim);
    uint32_t ext_outer, ext_inner;
    hs_open_elt(ctx, *lim, ext_len, &ext_outer, &ext_inner);
    *lim = ext_outer;

    uint32_t list_len = hs_read16(ctx, &ext_inner);
    uint32_t list_outer, list_inner;
    hs_open_elt(ctx, ext_inner, list_len, &list_outer, &list_inner);
    ext_inner = list_outer;

    hs_set32(eng, (uint32_t)OFF_CTX_curves, 0);
    while (list_inner > 0) {
        uint32_t curve_id = hs_read16(ctx, &list_inner);
        if (curve_id < 32) {
            uint32_t cur = hs_get32(eng, (uint32_t)OFF_CTX_curves);
            hs_set32(eng, (uint32_t)OFF_CTX_curves, cur | (1U << curve_id));
        }
    }

    hs_close_elt(ctx, list_inner);
    hs_close_elt(ctx, ext_inner);
}

/*
 * : read-ALPN-from-client ( lim -- lim )
 *
 * ALPN 확장(RFC 7301). 서버 선호 순서로 가장 낮은 인덱스의 프로토콜을 선택한다.
 */
static void
hs_read_ALPN_from_client(hs_run_ctx *ctx, uint32_t *lim)
{
    br_ssl_engine_context *eng = ctx->eng;

    /* 설정된 프로토콜이 없으면 무시 */
    if (hs_get16(eng,
            offsetof(br_ssl_engine_context, protocol_names_num)) == 0)
    {
        hs_read_ignore_16(ctx, lim);
        return;
    }

    uint32_t ext_len = hs_read16(ctx, lim);
    uint32_t ext_outer, ext_inner;
    hs_open_elt(ctx, *lim, ext_len, &ext_outer, &ext_inner);
    *lim = ext_outer;

    uint32_t list_len = hs_read16(ctx, &ext_inner);
    uint32_t list_outer, list_inner;
    hs_open_elt(ctx, ext_inner, list_len, &list_outer, &list_inner);
    ext_inner = list_outer;

    /*
     * found는 -2 (0xFFFFFFFE) 초기값으로 시작한다.
     * 부호 없는 비교를 사용하면 -2는 매우 큰 값이므로
     * 첫 번째 매치가 항상 더 작아서 found로 설정된다.
     */
    uint32_t found = (uint32_t)-2;

    while (list_inner > 0) {
        uint32_t name_len = (uint32_t)hs_read8(ctx, &list_inner);
        hs_read_blob(ctx, &list_inner,
            (uint32_t)offsetof(br_ssl_engine_context, pad), name_len);
        int32_t idx = hs_test_protocol_name(eng, (size_t)name_len);
        if (idx >= 0 && (uint32_t)idx < found) {
            found = (uint32_t)idx;
        }
    }

    hs_close_elt(ctx, list_inner);
    hs_close_elt(ctx, ext_inner);

    /*
     * found+1 을 selected_protocol에 기록한다.
     * 매치 없으면 found==(uint32_t)-2 → found+1 == 0xFFFF (16비트 기준)
     * 매치 있으면 found+1 == 인덱스+1
     */
    hs_set16(eng, offsetof(br_ssl_engine_context, selected_protocol),
        (uint16_t)(found + 1));
}

/* ======================================================================
 * 섹션 4: 핸드셰이크 쓰기 함수들
 * ====================================================================== */

/*
 * : lowest-1 ( bits -- n )
 *   dup ifnot drop -1 ret then
 *   0 begin dup2 >> 1 and 0= while 1+ repeat
 *   swap drop ;
 *
 * 비트 마스크에서 1이 설정된 가장 낮은 비트의 인덱스를 반환한다.
 * 비트가 없으면 -1을 반환한다.
 */
static inline int
hs_lowest_1(uint32_t bits)
{
    int n;
    if (!bits) return -1;
    for (n = 0; !((bits >> n) & 1); n++);
    return n;
}

/*
 * : write-list-auth ( do_write -- len )
 *
 * 클라이언트 인증 방법 목록을 쓰거나(do_write != 0),
 * 길이만 계산한다(do_write == 0).
 *
 *   rsa_fixed_ecdh(65), ecdsa_fixed_ecdh(66): ECDH 스위트일 때
 *   rsa_sign(1):  RSA 서명 지원 시
 *   ecdsa_sign(64): ECDSA 서명 지원 시
 */
static int
hs_write_list_auth(hs_run_ctx *ctx, int do_write)
{
    br_ssl_engine_context *eng = ctx->eng;
    uint16_t suite = hs_get16(eng,
        offsetof(br_ssl_engine_context, session) +
        offsetof(br_ssl_session_parameters, cipher_suite));
    int len = 0;

    if (hs_use_ecdh(suite)) {
        len += 2;
        if (do_write) { hs_write8(ctx, 65); hs_write8(ctx, 66); }
    }
    if (hs_supports_rsa_sign(eng)) {
        len += 1;
        if (do_write) hs_write8(ctx, 1);
    }
    if (hs_supports_ecdsa(eng)) {
        len += 1;
        if (do_write) hs_write8(ctx, 64);
    }
    return len;
}

/*
 * : write-signhash-inner2 ( dow algo hashes len id -- dow algo hashes len )
 *
 * hashes 비트마스크에 id에 해당하는 해시가 있으면 (algo, id) 쌍을 쓰고 len을 2 증가시킨다.
 */
static int
hs_write_signhash_inner2(hs_run_ctx *ctx,
    int do_write, int algo, uint32_t hashes, int len, int id)
{
    if (!(hashes & ((uint32_t)1 << id))) return len;
    len += 2;
    if (do_write) { hs_write8(ctx, (unsigned char)id);
                    hs_write8(ctx, (unsigned char)algo); }
    return len;
}

/*
 * : write-signhash-inner1 ( dow algo hashes -- dow len )
 *
 * 특정 algo에 대해 SHA-256(4), SHA-384(5), SHA-512(6), SHA-224(3), SHA-1(2) 순서로
 * 지원하는 해시를 나열한다.
 */
static int
hs_write_signhash_inner1(hs_run_ctx *ctx,
    int do_write, int algo, uint32_t hashes)
{
    int len = 0;
    len = hs_write_signhash_inner2(ctx, do_write, algo, hashes, len, 4);
    len = hs_write_signhash_inner2(ctx, do_write, algo, hashes, len, 5);
    len = hs_write_signhash_inner2(ctx, do_write, algo, hashes, len, 6);
    len = hs_write_signhash_inner2(ctx, do_write, algo, hashes, len, 3);
    len = hs_write_signhash_inner2(ctx, do_write, algo, hashes, len, 2);
    return len;
}

/*
 * : write-list-signhash ( do_write -- len )
 *
 * TLS 1.2 CertificateRequest에 들어가는 sign+hash 알고리즘 목록을 쓰거나 길이를 계산한다.
 */
static int
hs_write_list_signhash(hs_run_ctx *ctx, int do_write)
{
    br_ssl_engine_context *eng = ctx->eng;
    int len = 0;

    if (!hs_supports_rsa_sign(eng) && !hs_supports_ecdsa(eng)) {
        /* RSA/ECDSA 모두 없으면 정적 ECDH 전용 → 모든 것 지원 선언 */
        len  = hs_write_signhash_inner1(ctx, do_write, 1, 0x7C);
        len += hs_write_signhash_inner1(ctx, do_write, 3, 0x7C);
        return len;
    }
    if (hs_supports_rsa_sign(eng)) {
        uint32_t hx; uint32_t dummy;
        hs_supported_hash_functions(eng, &hx, &dummy);
        len += hs_write_signhash_inner1(ctx, do_write, 1, hx);
    }
    if (hs_supports_ecdsa(eng)) {
        uint32_t hx; uint32_t dummy;
        hs_supported_hash_functions(eng, &hx, &dummy);
        len += hs_write_signhash_inner1(ctx, do_write, 3, hx);
    }
    return len;
}

/*
 * : write-ServerHelloDone ( -- )
 *   14 write8 0 write24 ;
 */
static void
hs_write_ServerHelloDone(hs_run_ctx *ctx)
{
    hs_write8(ctx, 14);
    hs_write24(ctx, 0);
}

/*
 * : write-ServerKeyExchange ( -- )
 *
 * ECDHE 스위트일 때만 메시지를 전송한다.
 * 커브 선택 우선순위: Curve25519(29) > P-384/P-521 > 가장 낮은 ID
 */
static void
hs_write_ServerKeyExchange(hs_run_ctx *ctx)
{
    br_ssl_engine_context *eng = ctx->eng;
    uint16_t suite = hs_get16(eng,
        offsetof(br_ssl_engine_context, session) +
        offsetof(br_ssl_session_parameters, cipher_suite));

    if (!hs_use_ecdhe(suite)) return;

    /* 커브 선택 */
    uint32_t curves = hs_get32(eng, (uint32_t)OFF_CTX_curves);
    int curve_id;

    if (curves & 0x20000000U) {          /* Curve25519 = bit 29 */
        curve_id = 29;
    } else {
        uint32_t high = curves & 0x38000000U;  /* P-384(23), P-521(24) 영역 */
        curve_id = hs_lowest_1(high ? high : curves);
    }

    /* ECDHE 1단계: ephemeral 키 생성 + 포인트 계산 + 서명 */
    int sig_len = hs_do_ecdhe_part1(ctx, curve_id);
    if (sig_len < 0) hs_fail(eng, -sig_len);

    int tls12 = (hs_get16(eng, offsetof(br_ssl_engine_context, version_out))
                 >= 0x0303);

    /* ServerKeyExchange 헤더 */
    hs_write8(ctx, 12);
    uint32_t ecdhe_point_len = hs_get8(eng,
        offsetof(br_ssl_engine_context, ecdhe_point_len));
    uint32_t msg_len = (uint32_t)sig_len + ecdhe_point_len
                       + (uint32_t)(tls12 ? 2 : 0) + 6;
    hs_write24(ctx, msg_len);

    /* named_curve + curve_id */
    hs_write8(ctx, 3);
    hs_write16(ctx, (uint32_t)curve_id);

    /* 공개 포인트 (1바이트 길이 헤더) */
    hs_write_blob_head8(ctx,
        (uint32_t)offsetof(br_ssl_engine_context, ecdhe_point),
        ecdhe_point_len);

    /* TLS 1.2+: hash+signature 알고리즘 명시 */
    if (tls12) {
        uint32_t sign_hash_id = hs_get16(eng,
            (uint32_t)OFF_CTX_sign_hash_id);
        if (sign_hash_id < 0xFF00U) {
            hs_write16(ctx, sign_hash_id);
        } else {
            /* 상위 바이트가 0xFF인 경우: 해시 ID만 쓰고 sig 타입 추론 */
            hs_write8(ctx, (unsigned char)(sign_hash_id & 0xFF));
            /* use_rsa_ecdhe: -1→RSA(wire:1), 0→ECDSA(wire:3) */
            int is_rsa = hs_use_rsa_ecdhe(suite) ? 1 : 0;
            hs_write8(ctx, (unsigned char)(is_rsa ? 1 : 3));
        }
    }

    /* 서명 */
    hs_write16(ctx, (uint32_t)sig_len);
    hs_write_blob(ctx,
        (uint32_t)offsetof(br_ssl_engine_context, pad),
        (uint32_t)sig_len);
}

/*
 * : write-CertificateRequest ( -- )
 */
static void
hs_write_CertificateRequest(hs_run_ctx *ctx)
{
    br_ssl_engine_context *eng = ctx->eng;
    int tls12 = (hs_get16(eng, offsetof(br_ssl_engine_context, version_out))
                 >= 0x0303);

    /* 메시지 길이 계산 */
    uint32_t auth_len = (uint32_t)hs_write_list_auth(ctx, 0);
    uint32_t sh_len   = tls12 ? (uint32_t)hs_write_list_signhash(ctx, 0) : 0;
    uint32_t ta_len   = (uint32_t)hs_ta_names_total_length(ctx);
    uint32_t total    = auth_len + (tls12 ? 2 + sh_len : 0) + ta_len + 3;

    /* 헤더 */
    hs_write8(ctx, 13);
    hs_write24(ctx, total);

    /* 인증 방법 목록 */
    hs_write8(ctx, (unsigned char)auth_len);
    hs_write_list_auth(ctx, 1);

    /* sign+hash 목록 (TLS 1.2+) */
    if (tls12) {
        hs_write16(ctx, (uint32_t)sh_len);
        hs_write_list_signhash(ctx, 1);
    }

    /* 신뢰 앵커 DN 목록 */
    hs_write16(ctx, ta_len);
    hs_begin_ta_name_list(ctx);
    for (;;) {
        int32_t dn_len = hs_begin_ta_name(ctx);
        if (dn_len < 0) return;
        hs_write16(ctx, (uint32_t)dn_len);
        for (;;) {
            size_t chunk = hs_copy_dn_chunk(ctx);
            if (chunk == 0) break;
            hs_write_blob(ctx,
                (uint32_t)offsetof(br_ssl_engine_context, pad),
                (uint32_t)chunk);
        }
    }
}

/*
 * : write-ServerHello ( initial -- )
 *
 * ServerHello 메시지 전체를 작성한다.
 * 확장: Secure Renegotiation, Max Fragment Length, ALPN
 */
static void
hs_write_ServerHello(hs_run_ctx *ctx, int initial)
{
    br_ssl_engine_context *eng = ctx->eng;

    /* Secure Renegotiation 확장 길이 계산 */
    uint32_t ext_reneg_len = 0;
    if (hs_get8(eng, offsetof(br_ssl_engine_context, reneg)) == 2) {
        ext_reneg_len = initial ? 5 : 29;
    }

    /* Max Fragment Length 확장 길이 */
    uint32_t ext_mfl_len =
        hs_get8(eng, offsetof(br_ssl_engine_context, peer_log_max_frag_len))
        ? 5 : 0;

    /* ALPN 확장 길이 + 선택된 프로토콜 이름을 pad에 복사 */
    uint32_t ext_alpn_len = 0;
    uint16_t sel_proto = hs_get16(eng,
        offsetof(br_ssl_engine_context, selected_protocol));
    if (sel_proto) {
        size_t proto_name_len = hs_copy_protocol_name(eng,
            (size_t)(sel_proto - 1));
        ext_alpn_len = (uint32_t)proto_name_len + 7;
    }

    uint32_t ext_total = ext_reneg_len + ext_mfl_len + ext_alpn_len;

    /* message type + length */
    hs_write8(ctx, 2);
    hs_write24(ctx, 70 + ext_total + (ext_total ? 2 : 0));

    /* protocol version */
    hs_write16(ctx, hs_get16(eng,
        offsetof(br_ssl_engine_context, version_out)));

    /* server random (처음 4바이트는 0, 나머지 28바이트는 랜덤) */
    hs_bzero(eng,
        offsetof(br_ssl_engine_context, server_random), 4);
    hs_mkrand(eng,
        offsetof(br_ssl_engine_context, server_random) + 4, 28);
    hs_write_blob(ctx,
        (uint32_t)offsetof(br_ssl_engine_context, server_random), 32);

    /* session ID */
    hs_write8(ctx, 32);
    hs_write_blob(ctx,
        (uint32_t)offsetof(br_ssl_engine_context, session) +
        (uint32_t)offsetof(br_ssl_session_parameters, session_id), 32);

    /* cipher suite */
    hs_write16(ctx, hs_get16(eng,
        offsetof(br_ssl_engine_context, session) +
        offsetof(br_ssl_session_parameters, cipher_suite)));

    /* compression method: none */
    hs_write8(ctx, 0);

    /* extensions */
    if (ext_total) {
        hs_write16(ctx, ext_total);

        /* Secure Renegotiation */
        if (ext_reneg_len) {
            hs_write16(ctx, 0xFF01);
            hs_write16(ctx, ext_reneg_len - 4);
            /* initial: empty renegotiated_connection(길이 0)
             * renegotiation: 12바이트 client + 12바이트 server finished */
            uint32_t blob_len = ext_reneg_len - 5;
            uint32_t blob_off = (uint32_t)offsetof(br_ssl_engine_context,
                saved_finished) + (initial ? 0 : 0);
            hs_write_blob_head8(ctx, blob_off, blob_len);
        }

        /* Max Fragment Length */
        if (ext_mfl_len) {
            hs_write16(ctx, 0x0001);
            hs_write16(ctx, 1);
            hs_write8(ctx, (unsigned char)(
                hs_get8(eng, offsetof(br_ssl_engine_context,
                    peer_log_max_frag_len)) - 8));
        }

        /* ALPN */
        if (ext_alpn_len) {
            hs_write16(ctx, 0x0010);
            hs_write16(ctx, ext_alpn_len - 4);
            hs_write16(ctx, ext_alpn_len - 6);
            /* 이름은 이미 pad에 복사되어 있다 */
            uint32_t name_len = ext_alpn_len - 7;
            hs_write_blob_head8(ctx,
                (uint32_t)offsetof(br_ssl_engine_context, pad), name_len);
        }
    }
}

/* ======================================================================
 * 섹션 5: 핸드셰이크 읽기 함수들
 * ====================================================================== */

/*
 * : skip-ClientHello ( -- )
 *   read-handshake-header-core
 *   1 = ifnot ERR_UNEXPECTED fail then
 *   dup skip-blob drop ;
 *
 * 거부된 재협상 시도에서 ClientHello를 읽고 버린다.
 */
static void
hs_skip_ClientHello(hs_run_ctx *ctx)
{
    br_ssl_engine_context *eng = ctx->eng;
    uint32_t lim;
    int      type;

    hs_read_handshake_header_core(ctx, &lim, &type);
    if (type != 1) hs_fail(eng, BR_ERR_UNEXPECTED);
    hs_skip_blob(ctx, &lim, lim);
}

/*
 * : read-ClientHello ( -- resume )
 *
 * ClientHello를 파싱한다. 세션 재개이면 -1을, 아니면 0을 반환한다.
 */
static int
hs_read_ClientHello(hs_run_ctx *ctx)
{
    br_ssl_engine_context *eng = ctx->eng;
    uint32_t lim;
    int      type;

    hs_read_handshake_header(ctx, &lim, &type);
    if (type != 1) hs_fail(eng, BR_ERR_UNEXPECTED);

    /* 클라이언트 최대 버전 */
    uint32_t client_version_max = hs_read16(ctx, &lim);
    hs_set16(eng, (uint32_t)OFF_CTX_client_max_version,
        (uint16_t)client_version_max);

    /* 클라이언트 난수 32바이트 */
    hs_read_blob(ctx, &lim,
        (uint32_t)offsetof(br_ssl_engine_context, client_random), 32);

    /* 세션 ID */
    uint32_t sid_len = (uint32_t)hs_read8(ctx, &lim);
    if (sid_len > 32) hs_fail(eng, BR_ERR_OVERSIZED_ID);
    hs_set8(eng,
        offsetof(br_ssl_engine_context, session) +
        offsetof(br_ssl_session_parameters, session_id_len),
        (uint8_t)sid_len);
    hs_read_blob(ctx, &lim,
        (uint32_t)offsetof(br_ssl_engine_context, session) +
        (uint32_t)offsetof(br_ssl_session_parameters, session_id),
        sid_len);

    /* 세션 재개 확인 */
    int resume = hs_check_resume(ctx);

    /* 암호 스위트 목록 파싱 */
    uint32_t cs_list_len = hs_read16(ctx, &lim);
    uint32_t cs_outer, cs_inner;
    hs_open_elt(ctx, lim, cs_list_len, &cs_outer, &cs_inner);
    lim = cs_outer;

    int reneg_scsv   = 0;
    int resume_suite = 0;

    uint32_t css_addr, css_max_len;
    hs_addr_len_client_suites(&css_addr, &css_max_len);
    /* client_suites 버퍼 초기화 */
    hs_bzero(eng, (size_t)css_addr, (size_t)css_max_len);
    uint32_t css_off = css_addr;
    uint32_t css_max = css_addr + css_max_len;

    while (cs_inner > 0) {
        uint32_t suite = hs_read16(ctx, &cs_inner);

        /* 세션 재개 시 이전 스위트가 포함되어 있는지 확인 */
        if (resume) {
            uint16_t prev = hs_get16(eng,
                offsetof(br_ssl_engine_context, session) +
                offsetof(br_ssl_session_parameters, cipher_suite));
            if ((uint16_t)suite == prev) resume_suite = -1;
        }

        /* TLS_EMPTY_RENEGOTIATION_INFO_SCSV (0x00FF) */
        if (suite == 0x00FF) {
            if (hs_get8(eng, offsetof(br_ssl_engine_context, reneg)))
                hs_fail(eng, BR_ERR_BAD_SECRENEG);
            reneg_scsv = -1;
        }

        /* TLS_FALLBACK_SCSV (0x5600): 부당한 다운그레이드 감지 */
        if (suite == 0x5600) {
            uint16_t vmin = hs_get16(eng,
                offsetof(br_ssl_engine_context, version_min));
            uint16_t vmax = hs_get16(eng,
                offsetof(br_ssl_engine_context, version_max));
            if (client_version_max >= vmin && client_version_max < vmax) {
                client_version_max = (uint32_t)-1; /* 플래그: 다운그레이드 */
            }
        }

        /* 서버 지원 스위트인지 확인 */
        int32_t idx = hs_scan_suite(eng, (uint16_t)suite);
        if (idx >= 0) {
            if (hs_flag(eng, 0)) {
                /* 서버 선호 순서: idx 위치에 기록 */
                hs_set16(eng, css_addr + (uint32_t)(idx * 4) + 2,
                    (uint16_t)suite);
            } else {
                /* 클라이언트 순서: 뒤에 추가 */
                if (css_off >= css_max)
                    hs_fail(eng, BR_ERR_BAD_HANDSHAKE);
                hs_set16(eng, css_off, (uint16_t)suite);
                css_off += 4;
            }
        }
    }

    /* 압축 방법: 0(없음)이 있어야 한다 */
    uint32_t cm_len = (uint32_t)hs_read8(ctx, &lim);
    uint32_t cm_outer, cm_inner;
    hs_open_elt(ctx, lim, cm_len, &cm_outer, &cm_inner);
    lim = cm_outer;

    int ok_compression = 0;
    while (cm_inner > 0) {
        if (hs_read8(ctx, &cm_inner) == 0) ok_compression = -1;
    }
    hs_close_elt(ctx, cm_inner);

    /* 기본값 설정 */
    hs_set8(eng, offsetof(br_ssl_engine_context, server_name), 0);
    hs_set32(eng, (uint32_t)OFF_CTX_hashes, 0x0404);
    hs_set32(eng, (uint32_t)OFF_CTX_curves, 0x800000);

    /* 확장 파싱 */
    if (lim > 0) {
        uint32_t ext_list_len = hs_read16(ctx, &lim);
        uint32_t ext_outer, ext_inner;
        hs_open_elt(ctx, lim, ext_list_len, &ext_outer, &ext_inner);
        lim = ext_outer;

        while (ext_inner > 0) {
            uint32_t ext_type = hs_read16(ctx, &ext_inner);
            switch (ext_type) {
            case 0x0000: hs_read_client_sni(ctx,    &ext_inner); break;
            case 0x0001: hs_read_client_frag(ctx,   &ext_inner); break;
            case 0xFF01: hs_read_client_reneg(ctx,  &ext_inner); break;
            case 0x000D: hs_read_signatures(ctx,    &ext_inner); break;
            case 0x000A: hs_read_supported_curves(ctx, &ext_inner); break;
            case 0x0010: hs_read_ALPN_from_client(ctx, &ext_inner); break;
            default:     hs_read_ignore_16(ctx,     &ext_inner); break;
            }
        }
        hs_close_elt(ctx, ext_inner);
    }
    hs_close_elt(ctx, lim);

    /* 세션 재개: 스위트가 포함되지 않았으면 취소 */
    resume = resume & resume_suite;

    /* 버전 협상 */
    if ((int32_t)client_version_max < 0) {
        /* TLS_FALLBACK_SCSV 부당 다운그레이드 */
        hs_set16(eng, offsetof(br_ssl_engine_context, version_out),
            hs_get16(eng, (uint32_t)OFF_CTX_client_max_version));
        hs_fail_alert(ctx, 86);
    }

    uint32_t vmax = hs_get16(eng, offsetof(br_ssl_engine_context, version_max));
    uint32_t ver  = (client_version_max < vmax) ? client_version_max : vmax;

    if (ver < 0x0300) hs_fail(eng, BR_ERR_BAD_VERSION);

    if (client_version_max <
            hs_get16(eng, offsetof(br_ssl_engine_context, version_min)))
    {
        hs_fail_alert(ctx, 70);
    }

    /* 재개 시 이전 버전 강제 적용(가능한 경우) */
    if (resume) {
        uint16_t prev_ver = hs_get16(eng,
            offsetof(br_ssl_engine_context, session) +
            offsetof(br_ssl_session_parameters, version));
        if (prev_ver <= client_version_max) {
            ver = prev_ver;
        } else {
            resume = 0;
        }
    }

    hs_set16(eng, offsetof(br_ssl_engine_context, session) +
        offsetof(br_ssl_session_parameters, version), (uint16_t)ver);
    hs_set16(eng, offsetof(br_ssl_engine_context, version_in),  (uint16_t)ver);
    hs_set16(eng, offsetof(br_ssl_engine_context, version_out), (uint16_t)ver);

    int can_tls12 = (ver >= 0x0303);

    /* reneg 상태 갱신 */
    if (reneg_scsv)
        hs_set8(eng, offsetof(br_ssl_engine_context, reneg), 2);
    if (!hs_get8(eng, offsetof(br_ssl_engine_context, reneg)))
        hs_set8(eng, offsetof(br_ssl_engine_context, reneg), 1);

    if (!ok_compression) hs_fail_alert(ctx, 40);

    /* 해시 함수 필터링 */
    uint32_t hash_x; uint32_t hash_num;
    hs_supported_hash_functions(eng, &hash_x, &hash_num);
    uint32_t hashes = hs_get32(eng, (uint32_t)OFF_CTX_hashes);
    hashes &= (hash_x * 257) | 0xFFFF0000U;
    hs_set32(eng, (uint32_t)OFF_CTX_hashes, hashes);

    /* ECDHE 가능 여부 */
    int can_ecdhe = (((hashes & 0xFF) != 0) ? 1 : 0)
                  | (((hashes >> 8) != 0) ? 2 : 0);
    can_ecdhe <<= 12;

    /* 커브 필터링 */
    uint32_t curves = hs_get32(eng, (uint32_t)OFF_CTX_curves)
                    & hs_supported_curves(eng);
    hs_set32(eng, (uint32_t)OFF_CTX_curves, curves);
    if (!curves) can_ecdhe = 0;

    if (resume) return -1;

    /* 새 세션 ID 생성 */
    hs_mkrand(eng,
        offsetof(br_ssl_engine_context, session) +
        offsetof(br_ssl_session_parameters, session_id), 32);
    hs_set8(eng,
        offsetof(br_ssl_engine_context, session) +
        offsetof(br_ssl_session_parameters, session_id_len), 32);

    /* 스위트 목록 필터링: ECDHE 불가, TLS-1.2 전용 제거 */
    uint32_t src = css_addr;
    css_off = css_addr;
    while (src < css_max) {
        uint16_t s    = hs_get16(eng, src);
        uint16_t elts = hs_cipher_suite_to_elements(s);
        int      kt   = (elts >> 12) & 0xF;
        int      keep = 1;

        if (kt == 1 || kt == 2) {
            if (!(can_ecdhe & (1 << kt))) keep = 0;
        }
        if (!can_tls12 && ((elts & 0xF0) != 0x20)) keep = 0;

        if (keep) {
            hs_set16(eng, css_off + 2, elts);
            hs_set16(eng, css_off,     s);
            css_off += 4;
        }
        src += 4;
    }

    uint32_t num_suites = (css_off - css_addr) >> 2;
    if (!num_suites) hs_fail_alert(ctx, 40);
    hs_set8(eng, (uint32_t)OFF_CTX_client_suites_num,
        (uint8_t)num_suites);

    /* ALPN 확인 */
    uint16_t sprot = hs_get16(eng,
        offsetof(br_ssl_engine_context, selected_protocol));
    if (sprot == 0xFFFF) {
        if (hs_flag(eng, 3)) hs_fail_alert(ctx, 120);
        hs_set16(eng, offsetof(br_ssl_engine_context, selected_protocol), 0);
    }

    /* 정책 핸들러 호출 */
    if (!hs_call_policy_handler(ctx)) hs_fail_alert(ctx, 40);

    return 0;
}

/*
 * : read-ClientKeyExchange-header ( -- len )
 *   read-handshake-header 16 = ifnot ERR_UNEXPECTED fail then ;
 */
static uint32_t
hs_read_ClientKeyExchange_header(hs_run_ctx *ctx)
{
    uint32_t lim;
    int      type;
    hs_read_handshake_header(ctx, &lim, &type);
    if (type != 16) hs_fail(ctx->eng, BR_ERR_UNEXPECTED);
    return lim;
}

/*
 * : read-ClientKeyExchange-contents ( lim -- )
 */
static void
hs_read_ClientKeyExchange_contents(hs_run_ctx *ctx, uint32_t lim)
{
    br_ssl_engine_context *eng = ctx->eng;
    uint16_t suite = hs_get16(eng,
        offsetof(br_ssl_engine_context, session) +
        offsetof(br_ssl_session_parameters, cipher_suite));

    if (hs_use_rsa_keyx(suite)) {
        uint32_t enc_len = hs_read16(ctx, &lim);
        if (enc_len > 512) hs_fail(eng, BR_ERR_LIMIT_EXCEEDED);
        hs_read_blob(ctx, &lim,
            (uint32_t)offsetof(br_ssl_engine_context, pad), enc_len);
        hs_do_rsa_decrypt(ctx, (size_t)enc_len, hs_prf_id(suite));
    }

    int use_ecdhe = hs_use_ecdhe(suite) ? 1 : 0;
    int use_ecdh  = hs_use_ecdh(suite)  ? 1 : 0;

    if (use_ecdh || use_ecdhe) {
        uint32_t pt_len = (uint32_t)hs_read8(ctx, &lim);
        hs_read_blob(ctx, &lim,
            (uint32_t)offsetof(br_ssl_engine_context, pad), pt_len);
        int prf = hs_prf_id(suite);
        if (use_ecdhe)
            hs_do_ecdhe_part2(ctx, (size_t)pt_len, prf);
        else
            hs_do_ecdh(ctx, (size_t)pt_len, prf);
    }

    hs_close_elt(ctx, lim);
}

/*
 * : read-ClientKeyExchange ( -- )
 */
static void
hs_read_ClientKeyExchange(hs_run_ctx *ctx)
{
    uint32_t lim = hs_read_ClientKeyExchange_header(ctx);
    hs_read_ClientKeyExchange_contents(ctx, lim);
}

/*
 * : process-static-ECDH ( ktu -- )
 */
static void
hs_process_static_ECDH(hs_run_ctx *ctx, uint32_t ktu)
{
    br_ssl_engine_context *eng = ctx->eng;
    if ((ktu & 0x1F) != 0x12) hs_fail(eng, BR_ERR_WRONG_KEY_USAGE);
    uint16_t suite = hs_get16(eng,
        offsetof(br_ssl_engine_context, session) +
        offsetof(br_ssl_session_parameters, cipher_suite));
    if (!hs_use_ecdh(suite)) hs_fail(eng, BR_ERR_UNEXPECTED);
    hs_do_static_ecdh(ctx, hs_prf_id(suite));
}

/*
 * : read-CertificateVerify-header ( -- lim )
 */
static uint32_t
hs_read_CertificateVerify_header(hs_run_ctx *ctx)
{
    uint32_t lim;
    int      type;
    hs_compute_hash_CV(ctx);
    hs_read_handshake_header(ctx, &lim, &type);
    if (type != 15) hs_fail(ctx->eng, BR_ERR_UNEXPECTED);
    return lim;
}

/*
 * : read-CertificateVerify ( ktu -- )
 */
static void
hs_read_CertificateVerify(hs_run_ctx *ctx, uint32_t ktu)
{
    br_ssl_engine_context *eng = ctx->eng;

    if (!(ktu & 0x20)) hs_fail(eng, BR_ERR_WRONG_KEY_USAGE);
    int key_type = (int)(ktu & 0x0F);

    uint32_t lim = hs_read_CertificateVerify_header(ctx);

    int hash_id;
    if (hs_get16(eng, offsetof(br_ssl_engine_context, version_in))
            >= 0x0303)
    {
        /* TLS 1.2+: 명시적 hash+sig */
        uint32_t ha_sa = hs_read16(ctx, &lim);
        int sa = (int)(ha_sa & 0xFF);
        int ha = (int)(ha_sa >> 8);

        /* sig 알고리즘(1=RSA, 3=ECDSA) → key_type(1=RSA, 2=EC) 변환 */
        if (((sa + 1) >> 1) != key_type)
            hs_fail(eng, BR_ERR_BAD_SIGNATURE);

        if (ha < 2 || ha > 6) hs_fail(eng, BR_ERR_INVALID_ALGORITHM);
        hash_id = ha;
    } else {
        /* TLS 1.0/1.1: RSA→MD5+SHA1(0), ECDSA→SHA1(2) */
        hash_id = (key_type == 1) ? 0 : 2;
    }

    if (!hs_copy_hash_CV(ctx, hash_id))
        hs_fail(eng, BR_ERR_INVALID_ALGORITHM);

    uint32_t sig_len = hs_read16(ctx, &lim);
    if (sig_len > 512) hs_fail(eng, BR_ERR_LIMIT_EXCEEDED);
    hs_read_blob(ctx, &lim,
        (uint32_t)offsetof(br_ssl_engine_context, pad), sig_len);

    int err = hs_verify_CV_sig(ctx, (size_t)sig_len);
    if (err) hs_fail(eng, err);

    hs_close_elt(ctx, lim);
}

/*
 * : send-HelloRequest ( -- )
 *   flush-record
 *   begin can-output? not while wait-co drop repeat
 *   22 addr-record_type_out set8
 *   0 write8 0 write24 flush-record
 *   23 addr-record_type_out set8 ;
 */
static void
hs_send_HelloRequest(hs_run_ctx *ctx)
{
    br_ssl_engine_context *eng = ctx->eng;

    hs_flush_record(eng);
    while (!hs_can_output(eng)) hs_wait_co(ctx);

    hs_set8(eng, offsetof(br_ssl_engine_context, record_type_out), 22);
    hs_write8(ctx, 0);
    hs_write24(ctx, 0);
    hs_flush_record(eng);
    hs_set8(eng, offsetof(br_ssl_engine_context, record_type_out), 23);
}

/* ======================================================================
 * 섹션 6: 메인 코루틴
 * ====================================================================== */

/*
 * : do-handshake ( initial -- )
 */
static void
hs_do_handshake(hs_run_ctx *ctx, int initial)
{
    br_ssl_engine_context *eng = ctx->eng;

    hs_set8(eng, offsetof(br_ssl_engine_context, application_data), 0);
    hs_set8(eng, offsetof(br_ssl_engine_context, record_type_out), 22);
    hs_set16(eng, offsetof(br_ssl_engine_context, selected_protocol), 0);
    hs_multihash_init(eng);

    int resume = hs_read_ClientHello(ctx);

    if (hs_more_incoming_bytes(eng)) hs_fail(eng, BR_ERR_UNEXPECTED);

    if (resume) {
        /* 세션 재개 */
        hs_write_ServerHello(ctx, initial);
        hs_write_CCS_Finished(ctx, 0);
        hs_read_CCS_Finished(ctx, 0);
    } else {
        /* 새 핸드셰이크 */
        hs_write_ServerHello(ctx, initial);
        hs_write_Certificate(ctx);
        hs_write_ServerKeyExchange(ctx);

        if (hs_ta_names_total_length(ctx)) {
            hs_write_CertificateRequest(ctx);
        }
        hs_write_ServerHelloDone(ctx);
        hs_flush_record(eng);

        if (hs_ta_names_total_length(ctx)) {
            /* 클라이언트 인증서 처리 */
            uint32_t ktu = hs_read_Certificate(ctx, 0);

            if ((int32_t)ktu < 0) {
                /* 인증서 검증 실패 */
                if (!hs_flag(eng, 2)) {
                    hs_fail(eng, (int)(-(int32_t)ktu));
                }
                hs_read_ClientKeyExchange(ctx);
                uint32_t cv_lim = hs_read_CertificateVerify_header(ctx);
                hs_skip_blob(ctx, &cv_lim, cv_lim);

            } else if (ktu == 0) {
                /* 클라이언트가 인증서를 보내지 않음 */
                if (!hs_flag(eng, 2)) hs_fail(eng, BR_ERR_NO_CLIENT_AUTH);
                hs_read_ClientKeyExchange(ctx);

            } else {
                /* 인증서 검증 성공 */
                uint32_t cke_lim = hs_read_ClientKeyExchange_header(ctx);
                if (!cke_lim) {
                    /* 빈 ClientKeyExchange: 정적 ECDH */
                    hs_process_static_ECDH(ctx, ktu);
                } else {
                    hs_read_ClientKeyExchange_contents(ctx, cke_lim);
                    hs_read_CertificateVerify(ctx, ktu);
                }
            }
        } else {
            /* 클라이언트 인증 없음 */
            hs_read_ClientKeyExchange(ctx);
        }

        hs_read_CCS_Finished(ctx, 0);
        hs_write_CCS_Finished(ctx, 0);
        hs_save_session(ctx);
    }

    hs_set8(eng, offsetof(br_ssl_engine_context, application_data), 1);
    hs_set8(eng, offsetof(br_ssl_engine_context, record_type_out), 23);
}

/*
 * : main ( -- ! )
 *
 * TLS 서버 핸드셰이크 코루틴의 진입점.
 * 최초 핸드셰이크 후 재협상 요청을 무한 루프로 처리한다.
 */
static void
hs_server_main(hs_run_ctx *ctx)
{
    br_ssl_engine_context *eng = ctx->eng;

    /* 최초 핸드셰이크 (initial = -1) */
    hs_do_handshake(ctx, -1);

    for (;;) {
        int state = hs_wait_co(ctx);
        int low3  = state & 0x07;

        switch (low3) {
        case 0x00:
            /* 재협상 요청 */
            if (state & 0x10) {
                hs_set8(eng, offsetof(br_ssl_engine_context,
                    application_data), 0);
                hs_send_HelloRequest(ctx);
            }
            break;

        case 0x01:
            /* 클라이언트 측 재협상 시도 */
            {
                int reneg = hs_get8(eng,
                    offsetof(br_ssl_engine_context, reneg));
                if (reneg == 1 || hs_flag(eng, 1)) {
                    /* 거부: no_renegotiation 경고 전송 */
                    hs_skip_ClientHello(ctx);
                    hs_flush_record(eng);
                    while (!hs_can_output(eng)) hs_wait_co(ctx);
                    hs_send_warning(ctx, 100);
                    hs_set8(eng, offsetof(br_ssl_engine_context,
                        application_data), 1);
                    hs_set8(eng, offsetof(br_ssl_engine_context,
                        record_type_out), 23);
                } else {
                    hs_do_handshake(ctx, 0);
                }
            }
            break;

        default:
            hs_fail(eng, BR_ERR_UNEXPECTED);
            break;
        }
    }
}

/*
 * hs_server_run() — 외부 엔진 루프에서 호출하는 진입점
 *
 * BearSSL의 실제 런타임에서는 br_ssl_engine_context.cpu 필드가
 * 이 역할을 한다. 여기서는 hs_run_ctx를 직접 관리한다.
 *
 * 최초 호출(ctx->started == 0): hs_server_main()을 직접 실행.
 * 이후 호출: hs_resume()으로 코루틴을 재개.
 */
static void
hs_server_run(hs_run_ctx *ctx)
{
    if (!ctx->started) {
        ctx->started = 1;
        /* setjmp로 caller 지점 저장 후 코루틴 시작 */
        if (setjmp(ctx->caller_point) == 0) {
            hs_server_main(ctx);
        }
        /* hs_co()가 longjmp로 여기에 돌아옴 */
    } else {
        hs_resume(ctx);
    }
}

#endif /* SSL_HS_SERVER_T0_H */
