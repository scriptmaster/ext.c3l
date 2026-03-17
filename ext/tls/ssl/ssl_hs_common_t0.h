/*
 * ssl_hs_common_t0.h
 *
 * ssl_hs_common.t0의 모든 T0 단어(: ... ;)를 C로 변환한 파일.
 *
 * 파일 구성
 * ---------
 *  1. 코루틴 인프라        hs_run_ctx, hs_co(), hs_resume()
 *  2. 암호 스위트 테이블   cipher_suite_def[]
 *  3. co 없는 순수 함수들  check_len, read8, open_elt, scan_suite, ...
 *  4. co 포함 함수들       wait_co, read8_nc, write8, do_close, ...
 *
 * 의존성
 * ------
 *  ssl_hs_common_cc.h  (2단계: cc: 단어들)
 *  kern.h              (1단계: data_get16 등)
 */

#ifndef SSL_HS_COMMON_T0_H
#define SSL_HS_COMMON_T0_H

#include <setjmp.h>
#include <stddef.h>
#include <stdint.h>
#include "inner.h"
#include "kern.h"
#include "ssl_hs_common_cc.h"

/* ======================================================================
 * 섹션 1: 코루틴 인프라
 *
 * T0 VM에서 'co' opcode는 "goto t0_exit"로 구현된다.
 * VM은 ip/dp/rp 상태를 저장하고 C caller에게 반환한다.
 * Caller가 다시 run()을 호출하면 저장된 지점에서 재개된다.
 *
 * 순수 C에서는 setjmp/longjmp로 같은 효과를 낸다.
 * BearSSL 실제 런타임도 이 방식과 동등한 구조를 사용한다.
 *
 *  hs_co()    : T0의 'co' — 코루틴에서 caller로 제어 반환
 *  hs_resume(): caller가 코루틴을 재개할 때 호출
 * ====================================================================== */

typedef struct hs_run_ctx {
    br_ssl_engine_context *eng;

    /*
     * resume_point: hs_co()가 setjmp로 저장하는 지점.
     *   코루틴이 중단된 위치. hs_resume()이 longjmp로 이 지점으로 뛴다.
     *
     * caller_point: hs_resume()이 setjmp로 저장하는 지점.
     *   caller(엔진 루프)로 돌아가는 위치. hs_co()가 longjmp로 이 지점으로 뛴다.
     */
    jmp_buf resume_point;
    jmp_buf caller_point;

    /*
     * started: 0이면 아직 한 번도 시작하지 않은 상태.
     * 처음 hs_resume()을 호출할 때는 longjmp가 아니라
     * 직접 진입 함수(main)를 호출해야 한다.
     */
    int started;
} hs_run_ctx;

/*
 * hs_co() — T0의 'co' opcode에 대응
 *
 * T0 원문:
 *   add-cc: co { T0_CO(); }   →   goto t0_exit;
 *
 * 코루틴 안에서 호출된다.
 * caller_point로 longjmp해 caller에게 제어를 넘긴다.
 * caller가 hs_resume()으로 다시 깨우면 setjmp가 1을 반환하며 여기서 복귀한다.
 */
static inline void
hs_co(hs_run_ctx *ctx)
{
    if (setjmp(ctx->resume_point) == 0) {
        longjmp(ctx->caller_point, 1);  /* caller로 반환 */
    }
    /* longjmp로 재개되면 이 아래로 실행이 이어진다 */
}

/*
 * hs_resume() — caller가 코루틴을 한 번 실행(또는 재개)한다
 *
 * 반환하면 코루틴이 hs_co()를 호출해 yield했거나, 종료된 것이다.
 *
 * 최초 호출(ctx->started == 0)은 별도의 진입 래퍼가 처리한다.
 * 이 함수는 이미 시작된 코루틴을 재개하는 경로만 담당한다.
 */
static inline void
hs_resume(hs_run_ctx *ctx)
{
    if (setjmp(ctx->caller_point) == 0) {
        longjmp(ctx->resume_point, 1);  /* 코루틴 재개 */
    }
    /* 코루틴이 co()로 yield하면 여기로 돌아온다 */
}

/* ======================================================================
 * 섹션 2: 암호 스위트 테이블
 *
 * T0 원문:
 *   data: cipher-suite-def
 *   hexb| 000A 0024 | ...
 *   hexb| 0000 |        \ 종료자
 *
 * hexb| A B C D | 는 big-endian 바이트 스트림이다.
 * 각 행은 4바이트: [suite_hi][suite_lo][elts_hi][elts_lo]
 * 마지막 행은 2바이트 종료자 0x00 0x00.
 *
 * elts(elements) 인코딩 (4비트씩, MSB→LSB):
 *   [15:12] key_type   0=RSA-keyx  1=ECDHE-RSA  2=ECDHE-ECDSA
 *                      3=ECDH-RSA  4=ECDH-ECDSA
 *   [11:8]  cipher     0=3DES/CBC  1=AES128/CBC  2=AES256/CBC
 *                      3=AES128/GCM  4=AES256/GCM  5=ChaCha20
 *                      6=AES128/CCM  7=AES256/CCM
 *                      8=AES128/CCM8 9=AES256/CCM8
 *   [7:4]   mac        0=none  2=HMAC-SHA1  4=HMAC-SHA256  5=HMAC-SHA384
 *   [3:0]   prf        4=SHA-256  5=SHA-384
 * ====================================================================== */

static const uint8_t cipher_suite_def[] = {
    0x00,0x0A, 0x00,0x24,  /* TLS_RSA_WITH_3DES_EDE_CBC_SHA          */
    0x00,0x2F, 0x01,0x24,  /* TLS_RSA_WITH_AES_128_CBC_SHA           */
    0x00,0x35, 0x02,0x24,  /* TLS_RSA_WITH_AES_256_CBC_SHA           */
    0x00,0x3C, 0x01,0x44,  /* TLS_RSA_WITH_AES_128_CBC_SHA256        */
    0x00,0x3D, 0x02,0x44,  /* TLS_RSA_WITH_AES_256_CBC_SHA256        */
    0x00,0x9C, 0x03,0x04,  /* TLS_RSA_WITH_AES_128_GCM_SHA256        */
    0x00,0x9D, 0x04,0x05,  /* TLS_RSA_WITH_AES_256_GCM_SHA384        */
    0xC0,0x03, 0x40,0x24,  /* TLS_ECDH_ECDSA_WITH_3DES_EDE_CBC_SHA   */
    0xC0,0x04, 0x41,0x24,  /* TLS_ECDH_ECDSA_WITH_AES_128_CBC_SHA   */
    0xC0,0x05, 0x42,0x24,  /* TLS_ECDH_ECDSA_WITH_AES_256_CBC_SHA   */
    0xC0,0x08, 0x20,0x24,  /* TLS_ECDHE_ECDSA_WITH_3DES_EDE_CBC_SHA  */
    0xC0,0x09, 0x21,0x24,  /* TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA  */
    0xC0,0x0A, 0x22,0x24,  /* TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA  */
    0xC0,0x0D, 0x30,0x24,  /* TLS_ECDH_RSA_WITH_3DES_EDE_CBC_SHA    */
    0xC0,0x0E, 0x31,0x24,  /* TLS_ECDH_RSA_WITH_AES_128_CBC_SHA     */
    0xC0,0x0F, 0x32,0x24,  /* TLS_ECDH_RSA_WITH_AES_256_CBC_SHA     */
    0xC0,0x12, 0x10,0x24,  /* TLS_ECDHE_RSA_WITH_3DES_EDE_CBC_SHA   */
    0xC0,0x13, 0x11,0x24,  /* TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA    */
    0xC0,0x14, 0x12,0x24,  /* TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA    */
    0xC0,0x23, 0x21,0x44,  /* TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256 */
    0xC0,0x24, 0x22,0x55,  /* TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384 */
    0xC0,0x25, 0x41,0x44,  /* TLS_ECDH_ECDSA_WITH_AES_128_CBC_SHA256  */
    0xC0,0x26, 0x42,0x55,  /* TLS_ECDH_ECDSA_WITH_AES_256_CBC_SHA384  */
    0xC0,0x27, 0x11,0x44,  /* TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256   */
    0xC0,0x28, 0x12,0x55,  /* TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384   */
    0xC0,0x29, 0x31,0x44,  /* TLS_ECDH_RSA_WITH_AES_128_CBC_SHA256    */
    0xC0,0x2A, 0x32,0x55,  /* TLS_ECDH_RSA_WITH_AES_256_CBC_SHA384    */
    0xC0,0x2B, 0x23,0x04,  /* TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256 */
    0xC0,0x2C, 0x24,0x05,  /* TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384 */
    0xC0,0x2D, 0x43,0x04,  /* TLS_ECDH_ECDSA_WITH_AES_128_GCM_SHA256  */
    0xC0,0x2E, 0x44,0x05,  /* TLS_ECDH_ECDSA_WITH_AES_256_GCM_SHA384  */
    0xC0,0x2F, 0x13,0x04,  /* TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256   */
    0xC0,0x30, 0x14,0x05,  /* TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384   */
    0xC0,0x31, 0x33,0x04,  /* TLS_ECDH_RSA_WITH_AES_128_GCM_SHA256    */
    0xC0,0x32, 0x34,0x05,  /* TLS_ECDH_RSA_WITH_AES_256_GCM_SHA384    */
    0xC0,0x9C, 0x06,0x04,  /* TLS_RSA_WITH_AES_128_CCM                */
    0xC0,0x9D, 0x07,0x04,  /* TLS_RSA_WITH_AES_256_CCM                */
    0xC0,0xA0, 0x08,0x04,  /* TLS_RSA_WITH_AES_128_CCM_8              */
    0xC0,0xA1, 0x09,0x04,  /* TLS_RSA_WITH_AES_256_CCM_8              */
    0xC0,0xAC, 0x26,0x04,  /* TLS_ECDHE_ECDSA_WITH_AES_128_CCM        */
    0xC0,0xAD, 0x27,0x04,  /* TLS_ECDHE_ECDSA_WITH_AES_256_CCM        */
    0xC0,0xAE, 0x28,0x04,  /* TLS_ECDHE_ECDSA_WITH_AES_128_CCM_8      */
    0xC0,0xAF, 0x29,0x04,  /* TLS_ECDHE_ECDSA_WITH_AES_256_CCM_8      */
    0xCC,0xA8, 0x15,0x04,  /* TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305    */
    0xCC,0xA9, 0x25,0x04,  /* TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305  */
    0x00,0x00              /* 종료자                                   */
};

/* ======================================================================
 * 섹션 3: co 없는 순수 헬퍼 함수들
 * ====================================================================== */

/*
 * : NYI ( -- ! )
 *   "NOT YET IMPLEMENTED!" puts cr -1 fail ;
 */
static inline void
hs_NYI(hs_run_ctx *ctx)
{
    fprintf(stderr, "NOT YET IMPLEMENTED!\n");
    hs_fail(ctx->eng, -1);
}

/*
 * : flag? ( index -- bool )
 *   addr-flags get32 swap >> 1 and neg ;
 *
 * 엔진 flags 필드의 index번째 비트를 T0 불리언으로 반환한다.
 */
static inline int
hs_flag(const br_ssl_engine_context *eng, int index)
{
    uint32_t flags = eng->flags;
    return -((int)((flags >> index) & 1));
}

/*
 * : process-alert-byte ( x -- bool )
 *
 * T0 원문:
 *   addr-alert get8 case
 *     0 of  ← level 바이트 수신 단계
 *       dup 1 <> if drop 2 then
 *       addr-alert set8 0
 *     endof
 *     1 of  ← value 바이트 수신 단계 (alert field == 1은 "level=warning" 저장됨)
 *       0 addr-alert set8
 *       dup 100 = if 256 + fail then   ← no_renegotiation은 fatal 처리
 *       0=                              ← close_notify(0)이면 true
 *     endof
 *     drop 256 + fail                  ← fatal alert → 즉시 종료
 *   endcase ;
 *
 * alert 필드는 2바이트 알림 메시지의 파싱 상태를 추적한다.
 *   0  → level 바이트 아직 수신 안 됨
 *   1  → level=warning 수신, value 바이트 대기
 *   2  → level=fatal  수신, value 바이트 대기 (즉시 fail로 가므로 실제론 미사용)
 */
static int
hs_process_alert_byte(hs_run_ctx *ctx, int x)
{
    br_ssl_engine_context *eng = ctx->eng;
    uint8_t alert_state = hs_get8(eng, offsetof(br_ssl_engine_context, alert));

    switch (alert_state) {
    case 0:
        /* level 바이트 수신. 1(warning)이 아니면 모두 fatal로 간주 */
        if (x != 1) x = 2;
        hs_set8(eng, offsetof(br_ssl_engine_context, alert), (uint8_t)x);
        return 0;

    case 1:
        /* warning level의 value 바이트 수신 */
        hs_set8(eng, offsetof(br_ssl_engine_context, alert), 0);
        if (x == 100) {
            /* no_renegotiation: fatal로 처리 */
            hs_fail(ctx->eng, 256 + x);
        }
        return (x == 0) ? -1 : 0;  /* close_notify == 0 이면 true */

    default:
        /* fatal alert */
        hs_fail(ctx->eng, 256 + x);
        return 0; /* unreachable */
    }
}

/*
 * : process-alerts ( -- bool )
 *   0
 *   begin has-input? while read8-native process-alert-byte or repeat
 *   dup if 1 addr-shutdown_recv set8 then ;
 *
 * 버퍼에 있는 모든 alert 바이트를 처리한다.
 * close_notify를 받으면 shutdown_recv를 1로 설정하고 true를 반환한다.
 */
static int
hs_process_alerts(hs_run_ctx *ctx)
{
    br_ssl_engine_context *eng = ctx->eng;
    int got_close = 0;

    while (hs_has_input(eng)) {
        int b = hs_read8_native(eng);
        got_close |= hs_process_alert_byte(ctx, b);
    }
    if (got_close) {
        hs_set8(eng, offsetof(br_ssl_engine_context, shutdown_recv), 1);
    }
    return got_close ? -1 : 0;
}

/*
 * : check-len ( lim len -- lim )
 *   - dup 0< if ERR_BAD_PARAM fail then ;
 *
 * lim에서 len을 뺀다. 결과가 음수면 ERR_BAD_PARAM으로 fail한다.
 * 모든 read*/write* 함수에서 경계 검사에 사용된다.
 */
static inline uint32_t
hs_check_len(hs_run_ctx *ctx, uint32_t lim, uint32_t len)
{
    if (len > lim) {
        hs_fail(ctx->eng, BR_ERR_BAD_PARAM);
    }
    return lim - len;
}

/*
 * : open-elt ( lim len -- lim-outer lim-inner )
 *   dup { len }
 *   - dup 0< if ERR_BAD_PARAM fail then
 *   len ;
 *
 * 서브 엘리먼트를 연다. outer limit에서 inner length를 빼고,
 * outer_rem과 inner_lim 두 값을 반환한다.
 */
static inline void
hs_open_elt(hs_run_ctx *ctx,
    uint32_t lim, uint32_t len,
    uint32_t *out_outer, uint32_t *out_inner)
{
    if (len > lim) {
        hs_fail(ctx->eng, BR_ERR_BAD_PARAM);
    }
    *out_outer = lim - len;
    *out_inner = len;
}

/*
 * : close-elt ( lim -- )
 *   if ERR_BAD_PARAM fail then ;
 *
 * 서브 엘리먼트를 닫는다. lim이 0이 아니면 파싱 오류다.
 */
static inline void
hs_close_elt(hs_run_ctx *ctx, uint32_t lim)
{
    if (lim != 0) {
        hs_fail(ctx->eng, BR_ERR_BAD_PARAM);
    }
}

/*
 * : write16 ( n -- )
 *   dup 8 u>> write8 write8 ;
 *
 * : write24 ( n -- )
 *   dup 16 u>> write8 write16 ;
 *
 * 전방 선언 필요: write8은 co를 포함하므로 섹션 4에서 정의된다.
 */

/*
 * : scan-suite ( suite -- index )
 *   { suite }
 *   addr-suites_num get8 { num }
 *   0
 *   begin dup num < while
 *       dup 1 << addr-suites_buf + get16 suite = if ret then
 *       1+
 *   repeat
 *   drop -1 ;
 *
 * 엔진의 suites_buf에서 suite 값을 선형 탐색한다.
 * 찾으면 인덱스를, 없으면 -1을 반환한다.
 */
static int32_t
hs_scan_suite(const br_ssl_engine_context *eng, uint16_t suite)
{
    uint8_t  num = hs_get8(eng, offsetof(br_ssl_engine_context, suites_num));
    uint32_t buf_off = (uint32_t)offsetof(br_ssl_engine_context, suites_buf);
    int32_t  i;

    for (i = 0; i < (int32_t)num; i++) {
        /* suites_buf는 uint16_t 배열; 각 항목은 2바이트 */
        uint16_t s = hs_get16(eng, buf_off + (uint32_t)(i * 2));
        if (s == suite) return i;
    }
    return -1;
}

/*
 * : cipher-suite-to-elements ( suite -- elts )
 *   { id }
 *   cipher-suite-def
 *   begin
 *       dup 2+ swap data-get16
 *       dup ifnot 2drop 0 ret then
 *       id = if data-get16 ret then
 *       2+
 *   again ;
 *
 * cipher_suite_def 테이블을 선형 탐색한다.
 * 각 엔트리는 4바이트: [2바이트 suite_id][2바이트 elts].
 * suite_id가 0이면 종료, id와 일치하면 elts를 반환한다.
 */
static uint16_t
hs_cipher_suite_to_elements(uint16_t suite)
{
    size_t off = 0;

    for (;;) {
        /* big-endian으로 저장된 suite_id 읽기 */
        uint16_t id = (uint16_t)(
            ((uint16_t)cipher_suite_def[off]     << 8) |
             (uint16_t)cipher_suite_def[off + 1]);

        if (id == 0) return 0;      /* 종료자: 미지원 스위트 */

        uint16_t elts = (uint16_t)(
            ((uint16_t)cipher_suite_def[off + 2] << 8) |
             (uint16_t)cipher_suite_def[off + 3]);

        if (id == suite) return elts;

        off += 4;
    }
}

/*
 * : suite-supported? ( suite -- bool )
 *   dup 0x5600 = if drop -1 ret then
 *   cipher-suite-to-elements 0<> ;
 *
 * TLS_FALLBACK_SCSV(0x5600)도 지원으로 간주한다.
 */
static inline int
hs_suite_supported(uint16_t suite)
{
    if (suite == 0x5600) return -1;
    return hs_cipher_suite_to_elements(suite) != 0 ? -1 : 0;
}

/*
 * : expected-key-type ( suite -- key-type )
 *
 * elts[15:12] (key_type 필드)에 따라 BR_KEYTYPE_* 조합을 반환한다.
 */
static uint32_t
hs_expected_key_type(uint16_t suite)
{
    uint16_t elts     = hs_cipher_suite_to_elements(suite);
    unsigned key_type = (elts >> 12) & 0xF;

    switch (key_type) {
    case 0: return BR_KEYTYPE_RSA | BR_KEYTYPE_KEYX;
    case 1: return BR_KEYTYPE_RSA | BR_KEYTYPE_SIGN;
    case 2: return BR_KEYTYPE_EC  | BR_KEYTYPE_SIGN;
    case 3: return BR_KEYTYPE_EC  | BR_KEYTYPE_KEYX;
    case 4: return BR_KEYTYPE_EC  | BR_KEYTYPE_KEYX;
    default: return 0;
    }
}

/* elts[15:12] == 0 → RSA 키 교환 */
static inline int hs_use_rsa_keyx(uint16_t suite)
{ return ((hs_cipher_suite_to_elements(suite) >> 12) & 0xF) == 0 ? -1 : 0; }

/* elts[15:12] == 1 → ECDHE-RSA */
static inline int hs_use_rsa_ecdhe(uint16_t suite)
{ return ((hs_cipher_suite_to_elements(suite) >> 12) & 0xF) == 1 ? -1 : 0; }

/* elts[15:12] == 2 → ECDHE-ECDSA */
static inline int hs_use_ecdsa_ecdhe(uint16_t suite)
{ return ((hs_cipher_suite_to_elements(suite) >> 12) & 0xF) == 2 ? -1 : 0; }

/* elts[15:12] in {1,2} → ECDHE (RSA 또는 ECDSA 서명) */
static inline int hs_use_ecdhe(uint16_t suite)
{
    unsigned kt = (hs_cipher_suite_to_elements(suite) >> 12) & 0xF;
    return (kt >= 1 && kt <= 2) ? -1 : 0;
}

/* elts[15:12] > 2 → 정적 ECDH */
static inline int hs_use_ecdh(uint16_t suite)
{ return ((hs_cipher_suite_to_elements(suite) >> 12) & 0xF) > 2 ? -1 : 0; }

/*
 * : prf-id ( suite -- id )
 *   cipher-suite-to-elements 15 and ;
 *
 * elts[3:0]: PRF 해시 ID (4=SHA-256, 5=SHA-384)
 */
static inline int
hs_prf_id(uint16_t suite)
{
    return (int)(hs_cipher_suite_to_elements(suite) & 0xF);
}

/*
 * : use-tls12? ( suite -- bool )
 *   cipher-suite-to-elements 0xF0 and 0x20 <> ;
 *
 * MAC 필드가 HMAC/SHA-1(0x20)이 아니면 TLS 1.2 전용이다.
 */
static inline int
hs_use_tls12(uint16_t suite)
{
    return ((hs_cipher_suite_to_elements(suite) & 0xF0) != 0x20) ? -1 : 0;
}

/*
 * : switch-encryption ( is-client for-input -- )
 *
 * 협상된 암호 스위트에 따라 암호화 파라미터를 전환한다.
 * elts 필드를 분해해 적절한 hs_switch_*() 함수를 호출한다.
 */
static void
hs_switch_encryption(hs_run_ctx *ctx, int is_client, int for_input)
{
    br_ssl_engine_context *eng = ctx->eng;
    uint16_t suite = hs_get16(eng,
        offsetof(br_ssl_engine_context, session) +
        offsetof(br_ssl_session_parameters, cipher_suite));
    uint16_t elts        = hs_cipher_suite_to_elements(suite);
    int      prf_id      = (int)(elts & 0xF);
    int      mac_id      = (int)((elts >> 4) & 0xF);
    int      cipher_type = (int)((elts >> 8) & 0xF);

    switch (cipher_type) {
    case 0: /* 3DES/CBC */
        if (for_input)
            hs_switch_cbc_in(eng,  is_client, prf_id, mac_id, 0, 24);
        else
            hs_switch_cbc_out(eng, is_client, prf_id, mac_id, 0, 24);
        break;
    case 1: /* AES-128/CBC */
        if (for_input)
            hs_switch_cbc_in(eng,  is_client, prf_id, mac_id, 1, 16);
        else
            hs_switch_cbc_out(eng, is_client, prf_id, mac_id, 1, 16);
        break;
    case 2: /* AES-256/CBC */
        if (for_input)
            hs_switch_cbc_in(eng,  is_client, prf_id, mac_id, 1, 32);
        else
            hs_switch_cbc_out(eng, is_client, prf_id, mac_id, 1, 32);
        break;
    case 3: /* AES-128/GCM */
        if (for_input)
            hs_switch_aesgcm_in(eng,  is_client, prf_id, 16);
        else
            hs_switch_aesgcm_out(eng, is_client, prf_id, 16);
        break;
    case 4: /* AES-256/GCM */
        if (for_input)
            hs_switch_aesgcm_in(eng,  is_client, prf_id, 32);
        else
            hs_switch_aesgcm_out(eng, is_client, prf_id, 32);
        break;
    case 5: /* ChaCha20/Poly1305 */
        if (for_input)
            hs_switch_chapol_in(eng,  is_client, prf_id);
        else
            hs_switch_chapol_out(eng, is_client, prf_id);
        break;
    default: { /* AES/CCM (6~9) */
        /*
         * T0 원문:
         *   dup 1 and 4 << 16 + swap   ← key_len: bit0=1→32, bit0=0→16
         *   8 and 16 swap -             ← tag_len: bit3=0→16, bit3=1→8
         */
        unsigned cipher_id  = (unsigned)cipher_type;
        unsigned cipher_key = (cipher_id & 1) ? 32 : 16;
        unsigned tag_len    = (cipher_id & 8) ? 8  : 16;

        if (cipher_id > 9) {
            hs_fail(eng, BR_ERR_BAD_PARAM);
        }
        if (for_input)
            hs_switch_aesccm_in(eng,  is_client, prf_id, cipher_key, tag_len);
        else
            hs_switch_aesccm_out(eng, is_client, prf_id, cipher_key, tag_len);
        break;
    }
    }
}

/*
 * : read-list-sign-algos ( lim -- lim value )
 *
 * 지원하는 서명 알고리즘 목록을 파싱해 비트 필드로 반환한다.
 * 전방 선언: read8/read16/open-elt/close-elt 사용 (섹션 4에서 정의).
 */

/* ======================================================================
 * 섹션 4: co를 포함하는 함수들
 *
 * 이 함수들은 hs_co()를 직접 또는 간접적으로 호출한다.
 * 따라서 hs_run_ctx * 파라미터를 받아야 한다.
 * ====================================================================== */

/*
 * : wait-co ( -- state )
 *   co
 *   0
 *   addr-action get8 dup if
 *     case
 *       1 of 0 do-close endof
 *       2 of addr-application_data get8 1 = if 0x10 or then endof
 *     endcase
 *   else drop then
 *   addr-close_received get8 ifnot
 *     has-input? if
 *       addr-record_type_in get8 case
 *         20 of 0x02 or endof
 *         21 of process-alerts if -1 do-close then endof
 *         22 of 0x01 or endof
 *         drop 0x04 or 0
 *       endcase
 *     then
 *   then
 *   can-output? if 0x08 or then ;
 *
 * 반환값 비트 의미:
 *   0x01  핸드셰이크 데이터 수신 가능
 *   0x02  CCS 데이터 수신 가능
 *   0x04  그 외 데이터 수신 가능
 *   0x08  출력 버퍼에 쓸 공간 있음
 *   0x10  재협상 요청이 있고 무시하면 안 됨
 */
/* do-close 전방 선언 */
static void hs_do_close(hs_run_ctx *ctx, int cnr);

static int
hs_wait_co(hs_run_ctx *ctx)
{
    br_ssl_engine_context *eng = ctx->eng;
    int state = 0;

    /* co: caller에게 제어를 넘기고 재개를 기다린다 */
    hs_co(ctx);

    /* action 필드 처리 */
    uint8_t action = hs_get8(eng, offsetof(br_ssl_engine_context, action));
    if (action) {
        switch (action) {
        case 1:
            hs_do_close(ctx, 0);
            break;
        case 2:
            if (hs_get8(eng, offsetof(br_ssl_engine_context,
                         application_data)) == 1)
            {
                state |= 0x10;
            }
            break;
        }
    }

    /* close_received 미수신 시 입력 레코드 타입 분류 */
    if (!hs_get8(eng, offsetof(br_ssl_engine_context, close_received))) {
        if (hs_has_input(eng)) {
            uint8_t rtype = hs_get8(eng,
                offsetof(br_ssl_engine_context, record_type_in));
            switch (rtype) {
            case 20: /* ChangeCipherSpec */
                state |= 0x02;
                break;
            case 21: /* Alert */
                if (hs_process_alerts(ctx)) {
                    hs_do_close(ctx, -1);
                }
                break;
            case 22: /* Handshake */
                state |= 0x01;
                break;
            default:
                state |= 0x04;
                break;
            }
        }
    }

    if (hs_can_output(eng)) state |= 0x08;

    return state;
}

/*
 * : wait-for-close ( cnr -- cnr )
 *   co
 *   dup ifnot
 *     has-input? if
 *       addr-record_type_in get8 21 = if
 *         drop process-alerts
 *         0 addr-application_data set8
 *       else
 *         discard-input
 *       then
 *     then
 *   then ;
 */
static int
hs_wait_for_close(hs_run_ctx *ctx, int cnr)
{
    br_ssl_engine_context *eng = ctx->eng;

    hs_co(ctx);

    if (!cnr) {
        if (hs_has_input(eng)) {
            uint8_t rtype = hs_get8(eng,
                offsetof(br_ssl_engine_context, record_type_in));
            if (rtype == 21) {
                cnr = hs_process_alerts(ctx);
                hs_set8(eng, offsetof(br_ssl_engine_context,
                             application_data), 0);
            } else {
                hs_discard_input(eng);
            }
        }
    }
    return cnr;
}

/*
 * : do-close ( cnr -- ! )
 *   { cnr }
 *   addr-application_data get8 cnr not and 1 << addr-application_data set8
 *   flush-record
 *   begin can-output? not while cnr wait-for-close >cnr repeat
 *   0 send-warning
 *   cnr
 *   begin
 *     dup can-output? and if ERR_OK fail then
 *     wait-for-close
 *   again ;
 */
/* send-warning 전방 선언 */
static void hs_send_warning(hs_run_ctx *ctx, int alert);

static void
hs_do_close(hs_run_ctx *ctx, int cnr)
{
    br_ssl_engine_context *eng = ctx->eng;

    /* application_data 플래그 조정:
     * was=1 && cnr=0 이면 2로 (close_notify 대기 중),
     * 그 외에는 0으로 */
    uint8_t ad = hs_get8(eng, offsetof(br_ssl_engine_context, application_data));
    uint8_t new_ad = (uint8_t)((ad & (uint8_t)(!cnr)) << 1);
    hs_set8(eng, offsetof(br_ssl_engine_context, application_data), new_ad);

    hs_flush_record(eng);

    /* 출력 버퍼에 공간이 생길 때까지 대기 */
    while (!hs_can_output(eng)) {
        cnr = hs_wait_for_close(ctx, cnr);
    }

    /* close_notify 알림(warning level, alert=0) 전송 */
    hs_send_warning(ctx, 0);

    /* 전송 완료 + close_notify 수신까지 대기 */
    for (;;) {
        if (cnr && hs_can_output(eng)) {
            hs_fail(eng, BR_ERR_OK);
        }
        cnr = hs_wait_for_close(ctx, cnr);
    }
}

/*
 * : send-alert ( level alert -- )
 *   21 addr-record_type_out set8
 *   swap write8-native drop write8-native drop
 *   flush-record ;
 *
 * write8-native는 co를 포함하지 않는 cc: 함수이므로 직접 호출 가능.
 * 단, 호출 전 출력 버퍼에 공간이 있어야 한다 (caller 책임).
 */
static void
hs_send_alert(hs_run_ctx *ctx, int level, int alert)
{
    br_ssl_engine_context *eng = ctx->eng;
    hs_set8(eng, offsetof(br_ssl_engine_context, record_type_out), 21);
    hs_write8_native(eng, (unsigned char)level);
    hs_write8_native(eng, (unsigned char)alert);
    hs_flush_record(eng);
}

/*
 * : send-warning ( alert -- )
 *   1 swap send-alert ;
 */
static void
hs_send_warning(hs_run_ctx *ctx, int alert)
{
    hs_send_alert(ctx, 1, alert);
}

/*
 * : fail-alert ( alert -- ! )
 *   { alert }
 *   flush-record
 *   begin can-output? not while wait-co drop repeat
 *   2 alert send-alert
 *   begin can-output? not while wait-co drop repeat
 *   alert 512 + fail ;
 */
static void
hs_fail_alert(hs_run_ctx *ctx, int alert)
{
    br_ssl_engine_context *eng = ctx->eng;

    hs_flush_record(eng);
    while (!hs_can_output(eng)) hs_wait_co(ctx);

    hs_send_alert(ctx, 2, alert);

    while (!hs_can_output(eng)) hs_wait_co(ctx);

    hs_fail(eng, alert + 512);
}

/*
 * : wait-for-handshake ( -- )
 *   wait-co 0x07 and 0x01 > if ERR_UNEXPECTED fail then ;
 *
 * 핸드셰이크 데이터가 아닌 것이 오면 오류로 처리한다.
 */
static void
hs_wait_for_handshake(hs_run_ctx *ctx)
{
    int state = hs_wait_co(ctx) & 0x07;
    if (state > 0x01) {
        hs_fail(ctx->eng, BR_ERR_UNEXPECTED);
    }
}

/*
 * : wait-rectype-out ( rectype -- )
 *   { rectype }
 *   flush-record
 *   begin
 *     can-output? if rectype addr-record_type_out set8 ret then
 *     wait-co drop
 *   again ;
 */
static void
hs_wait_rectype_out(hs_run_ctx *ctx, int rectype)
{
    br_ssl_engine_context *eng = ctx->eng;

    hs_flush_record(eng);
    for (;;) {
        if (hs_can_output(eng)) {
            hs_set8(eng, offsetof(br_ssl_engine_context, record_type_out),
                (uint8_t)rectype);
            return;
        }
        hs_wait_co(ctx);
    }
}

/*
 * : read8-nc ( -- x )
 *   begin
 *     read8-native dup 0< ifnot ret then
 *     drop wait-for-handshake
 *   again ;
 *
 * 1바이트가 도착할 때까지 블로킹한다.
 */
static int
hs_read8_nc(hs_run_ctx *ctx)
{
    for (;;) {
        int x = hs_read8_native(ctx->eng);
        if (x >= 0) return x;
        hs_wait_for_handshake(ctx);
    }
}

/*
 * : read8 ( lim -- lim x )
 *   1 check-len read8-nc ;
 */
static int
hs_read8(hs_run_ctx *ctx, uint32_t *lim)
{
    *lim = hs_check_len(ctx, *lim, 1);
    return hs_read8_nc(ctx);
}

/*
 * : read16 ( lim -- lim n )
 *   2 check-len read8-nc 8 << read8-nc + ;
 */
static uint32_t
hs_read16(hs_run_ctx *ctx, uint32_t *lim)
{
    *lim = hs_check_len(ctx, *lim, 2);
    uint32_t hi = (uint32_t)hs_read8_nc(ctx);
    uint32_t lo = (uint32_t)hs_read8_nc(ctx);
    return (hi << 8) | lo;
}

/*
 * : read24 ( lim -- lim n )
 *   3 check-len read8-nc 8 << read8-nc + 8 << read8-nc + ;
 */
static uint32_t
hs_read24(hs_run_ctx *ctx, uint32_t *lim)
{
    *lim = hs_check_len(ctx, *lim, 3);
    uint32_t b0 = (uint32_t)hs_read8_nc(ctx);
    uint32_t b1 = (uint32_t)hs_read8_nc(ctx);
    uint32_t b2 = (uint32_t)hs_read8_nc(ctx);
    return (b0 << 16) | (b1 << 8) | b2;
}

/*
 * : read-blob ( lim addr len -- lim )
 *   { addr len }
 *   len check-len
 *   addr len
 *   begin
 *     read-chunk-native
 *     dup 0 = if 2drop ret then
 *     wait-for-handshake
 *   again ;
 *
 * 엔진 컨텍스트의 addr 오프셋으로 len 바이트를 읽어 들인다.
 */
static void
hs_read_blob(hs_run_ctx *ctx, uint32_t *lim, uint32_t addr, uint32_t len)
{
    *lim = hs_check_len(ctx, *lim, len);
    while (len > 0) {
        hs_read_chunk_native(ctx->eng, &addr, &len);
        if (len == 0) return;
        hs_wait_for_handshake(ctx);
    }
}

/*
 * : skip-blob ( lim len -- lim )
 *   swap over check-len swap
 *   begin dup while read8-nc drop 1- repeat
 *   drop ;
 */
static void
hs_skip_blob(hs_run_ctx *ctx, uint32_t *lim, uint32_t len)
{
    *lim = hs_check_len(ctx, *lim, len);
    while (len > 0) {
        hs_read8_nc(ctx);
        len--;
    }
}

/*
 * : read-ignore-16 ( lim -- lim )
 *   read16 skip-blob ;
 */
static void
hs_read_ignore_16(hs_run_ctx *ctx, uint32_t *lim)
{
    uint32_t skip_len = hs_read16(ctx, lim);
    hs_skip_blob(ctx, lim, skip_len);
}

/*
 * : write8 ( n -- )
 *   begin
 *     dup write8-native if drop ret then
 *     wait-co drop
 *   again ;
 */
static void
hs_write8(hs_run_ctx *ctx, unsigned char n)
{
    while (!hs_write8_native(ctx->eng, n)) {
        hs_wait_co(ctx);
    }
}

/*
 * : write16 ( n -- )
 *   dup 8 u>> write8 write8 ;
 */
static void
hs_write16(hs_run_ctx *ctx, uint32_t n)
{
    hs_write8(ctx, (unsigned char)(n >> 8));
    hs_write8(ctx, (unsigned char)(n & 0xFF));
}

/*
 * : write24 ( n -- )
 *   dup 16 u>> write8 write16 ;
 */
static void
hs_write24(hs_run_ctx *ctx, uint32_t n)
{
    hs_write8(ctx, (unsigned char)(n >> 16));
    hs_write16(ctx, n & 0xFFFF);
}

/*
 * : write-blob ( addr len -- )
 *   begin
 *     write-blob-chunk
 *     dup 0 = if 2drop ret then
 *     wait-co drop
 *   again ;
 */
static void
hs_write_blob(hs_run_ctx *ctx, uint32_t addr, uint32_t len)
{
    while (len > 0) {
        hs_write_blob_chunk(ctx->eng, &addr, &len);
        if (len == 0) return;
        hs_wait_co(ctx);
    }
}

/*
 * : write-blob-head8 ( addr len -- )
 *   dup write8 write-blob ;
 */
static void
hs_write_blob_head8(hs_run_ctx *ctx, uint32_t addr, uint32_t len)
{
    hs_write8(ctx, (unsigned char)len);
    hs_write_blob(ctx, addr, len);
}

/*
 * : write-blob-head16 ( addr len -- )
 *   dup write16 write-blob ;
 */
static void
hs_write_blob_head16(hs_run_ctx *ctx, uint32_t addr, uint32_t len)
{
    hs_write16(ctx, len);
    hs_write_blob(ctx, addr, len);
}

/*
 * : read-handshake-header-core ( -- lim type )
 *   read8-nc 3 read24 swap drop swap ;
 *
 * 핸드셰이크 메시지 헤더를 읽는다: type(1바이트) + length(3바이트).
 * read24에 넘기는 lim=3은 길이 필드 자체의 크기 검사용이므로 버린다.
 * 반환: (lim=length, type)
 */
static void
hs_read_handshake_header_core(hs_run_ctx *ctx,
    uint32_t *out_lim, int *out_type)
{
    int      type = hs_read8_nc(ctx);
    uint32_t dummy_lim = 3;
    uint32_t length    = hs_read24(ctx, &dummy_lim);

    *out_type = type;
    *out_lim  = length;
}

/*
 * : read-handshake-header ( -- lim type )
 *   begin
 *     read-handshake-header-core dup 0= while
 *     drop if ERR_BAD_HANDSHAKE fail then
 *   repeat ;
 *
 * HelloRequest(type=0) 메시지는 건너뛴다.
 * 길이가 0이 아닌 HelloRequest는 오류다.
 */
static void
hs_read_handshake_header(hs_run_ctx *ctx,
    uint32_t *out_lim, int *out_type)
{
    for (;;) {
        hs_read_handshake_header_core(ctx, out_lim, out_type);
        if (*out_type != 0) return;         /* HelloRequest 아니면 반환 */
        if (*out_lim  != 0)                 /* 길이 있는 HelloRequest는 오류 */
            hs_fail(ctx->eng, BR_ERR_BAD_HANDSHAKE);
        /* type=0, lim=0: HelloRequest 무시하고 다음 헤더 읽기 */
    }
}

/*
 * : read-list-sign-algos ( lim -- lim value )
 *   0 { hashes }
 *   read16 open-elt
 *   begin dup while
 *     read8 { hash } read8 { sign }
 *     hash 8 = if
 *       sign 15 <= if 1 sign 16 + << hashes or >hashes then
 *     else
 *       hash 2 >= hash 6 <= and
 *       sign 1 = sign 3 = or
 *       and if
 *         hashes 1 sign 1- 2 << hash + << or >hashes
 *       then
 *     then
 *   repeat
 *   close-elt
 *   hashes ;
 */
static uint32_t
hs_read_list_sign_algos(hs_run_ctx *ctx, uint32_t *lim)
{
    uint32_t hashes = 0;
    uint32_t list_len = hs_read16(ctx, lim);
    uint32_t outer, inner;

    hs_open_elt(ctx, *lim, list_len, &outer, &inner);
    *lim = outer;

    while (inner > 0) {
        int hash = hs_read8(ctx, &inner);
        int sign = hs_read8(ctx, &inner);

        if (hash == 8) {
            /* 새로운 알고리즘 식별자 */
            if (sign <= 15) {
                hashes |= (1U << (sign + 16));
            }
        } else {
            /* 기존 hash(2~6) + sign(1=RSA, 3=ECDSA) 조합 */
            if (hash >= 2 && hash <= 6 && (sign == 1 || sign == 3)) {
                hashes |= (1U << ((sign - 1) * 4 + hash));
            }
        }
    }

    hs_close_elt(ctx, inner);
    return hashes;
}

/*
 * : compute-Finished ( from_client -- )
 *   dup addr-saved_finished swap ifnot 12 + then swap
 *   addr-cipher_suite get16 prf-id compute-Finished-inner
 *   addr-pad 12 memcpy ;
 */
static void
hs_compute_Finished(hs_run_ctx *ctx, int from_client)
{
    br_ssl_engine_context *eng = ctx->eng;
    uint16_t suite   = hs_get16(eng,
        offsetof(br_ssl_engine_context, session) +
        offsetof(br_ssl_session_parameters, cipher_suite));
    int prf = hs_prf_id(suite);

    hs_compute_Finished_inner(eng, from_client, prf);

    /* pad의 첫 12바이트를 saved_finished의 적절한 위치에 저장 */
    size_t dst_off = offsetof(br_ssl_engine_context, saved_finished);
    if (!from_client) dst_off += 12;  /* server finished는 +12 위치 */
    hs_memcpy(eng, dst_off,
        offsetof(br_ssl_engine_context, pad), 12);
}

/*
 * : write-Finished ( from_client -- )
 *   compute-Finished
 *   20 write8 12 write24 addr-pad 12 write-blob ;
 */
static void
hs_write_Finished(hs_run_ctx *ctx, int from_client)
{
    br_ssl_engine_context *eng = ctx->eng;

    hs_compute_Finished(ctx, from_client);
    hs_write8(ctx, 20);    /* Finished message type */
    hs_write24(ctx, 12);   /* length = 12 */
    hs_write_blob(ctx,
        (uint32_t)offsetof(br_ssl_engine_context, pad), 12);
}

/*
 * : read-Finished ( from_client -- )
 *   compute-Finished
 *   read-handshake-header 20 <> if ERR_UNEXPECTED fail then
 *   addr-pad 12 + 12 read-blob
 *   close-elt
 *   addr-pad dup 12 + 12 memcmp ifnot ERR_BAD_FINISHED fail then ;
 */
static void
hs_read_Finished(hs_run_ctx *ctx, int from_client)
{
    br_ssl_engine_context *eng = ctx->eng;
    uint32_t lim;
    int      type;

    hs_compute_Finished(ctx, from_client);

    hs_read_handshake_header(ctx, &lim, &type);
    if (type != 20) hs_fail(eng, BR_ERR_UNEXPECTED);

    /* pad+12 위치에 수신한 Finished 값 저장 */
    uint32_t dst = (uint32_t)offsetof(br_ssl_engine_context, pad) + 12;
    hs_read_blob(ctx, &lim, dst, 12);
    hs_close_elt(ctx, lim);

    /* 계산값(pad[0..11])과 수신값(pad[12..23]) 비교 */
    if (!hs_memcmp(eng,
            offsetof(br_ssl_engine_context, pad),
            offsetof(br_ssl_engine_context, pad) + 12,
            12))
    {
        hs_fail(eng, BR_ERR_BAD_FINISHED);
    }
}

/*
 * : read-CCS-Finished ( is-client -- )
 *   has-input? if
 *     addr-record_type_in get8 20 <> if ERR_UNEXPECTED fail then
 *   else
 *     begin
 *       wait-co 0x07 and dup 0x02 <> while
 *       if ERR_UNEXPECTED fail then
 *     repeat
 *     drop
 *   then
 *   read8-nc 1 <> more-incoming-bytes? or if ERR_BAD_CCS fail then
 *   dup 1 switch-encryption
 *   not read-Finished ;
 */
static void
hs_read_CCS_Finished(hs_run_ctx *ctx, int is_client)
{
    br_ssl_engine_context *eng = ctx->eng;

    if (hs_has_input(eng)) {
        uint8_t rtype = hs_get8(eng,
            offsetof(br_ssl_engine_context, record_type_in));
        if (rtype != 20) hs_fail(eng, BR_ERR_UNEXPECTED);
    } else {
        for (;;) {
            int s = hs_wait_co(ctx) & 0x07;
            if (s == 0x02) break;
            if (s) hs_fail(eng, BR_ERR_UNEXPECTED);
        }
    }

    /* CCS 내용은 정확히 0x01 한 바이트여야 한다 */
    if (hs_read8_nc(ctx) != 1 || hs_more_incoming_bytes(eng)) {
        hs_fail(eng, BR_ERR_BAD_CCS);
    }

    hs_switch_encryption(ctx, is_client, 1 /* for_input */);
    hs_read_Finished(ctx, !is_client);
}

/*
 * : write-CCS-Finished ( is-client -- )
 *   20 wait-rectype-out
 *   1 write8
 *   flush-record
 *   dup 0 switch-encryption
 *   22 wait-rectype-out
 *   write-Finished
 *   flush-record ;
 */
static void
hs_write_CCS_Finished(hs_run_ctx *ctx, int is_client)
{
    br_ssl_engine_context *eng = ctx->eng;

    hs_wait_rectype_out(ctx, 20);   /* ChangeCipherSpec 레코드 타입으로 전환 */
    hs_write8(ctx, 1);              /* CCS 내용: 0x01 */
    hs_flush_record(eng);

    hs_switch_encryption(ctx, is_client, 0 /* for_output */);

    hs_wait_rectype_out(ctx, 22);   /* Handshake 레코드 타입으로 전환 */
    hs_write_Finished(ctx, is_client);
    hs_flush_record(eng);
}

/*
 * : write-Certificate ( -- total_chain_len )
 *   11 write8
 *   total-chain-length dup
 *   dup 3 + write24 write24
 *   begin
 *     begin-cert
 *     dup 0< if drop ret then write24
 *     begin copy-cert-chunk dup while
 *       addr-pad swap write-blob
 *     repeat
 *     drop
 *   again ;
 */
static uint32_t
hs_write_Certificate(hs_run_ctx *ctx)
{
    br_ssl_engine_context *eng = ctx->eng;
    uint32_t total = hs_total_chain_length(eng);

    hs_write8(ctx, 11);            /* Certificate message type */
    hs_write24(ctx, total + 3);    /* 전체 길이: chain length 헤더(3) + chain */
    hs_write24(ctx, total);        /* chain length */

    for (;;) {
        int32_t cert_len = hs_begin_cert(eng);
        if (cert_len < 0) return total;  /* 체인 끝 */

        hs_write24(ctx, (uint32_t)cert_len);

        for (;;) {
            size_t chunk = hs_copy_cert_chunk(eng);
            if (chunk == 0) break;
            hs_write_blob(ctx,
                (uint32_t)offsetof(br_ssl_engine_context, pad),
                (uint32_t)chunk);
        }
    }
}

/*
 * : read-Certificate ( by_client -- key-type-usages )
 *   read-handshake-header 11 = ifnot ERR_UNEXPECTED fail then
 *   dup 3 = if read24 if ERR_BAD_PARAM fail then swap drop ret then
 *   swap x509-start-chain
 *   read24 open-elt
 *   begin dup while
 *     read24 open-elt
 *     dup x509-start-cert
 *     begin dup while
 *       dup 256 > if 256 else dup then { len }
 *       addr-pad len read-blob
 *       len x509-append
 *     repeat
 *     close-elt x509-end-cert
 *   repeat
 *   close-elt close-elt
 *   x509-end-chain dup if neg ret then drop
 *   get-key-type-usages ;
 */
static uint32_t
hs_read_Certificate(hs_run_ctx *ctx, int by_client)
{
    br_ssl_engine_context *eng = ctx->eng;
    uint32_t lim;
    int      type;

    hs_read_handshake_header(ctx, &lim, &type);
    if (type != 11) hs_fail(eng, BR_ERR_UNEXPECTED);

    /* 빈 체인 처리: 3바이트 = 체인 길이 필드(0x000000)만 있는 경우 */
    if (lim == 3) {
        if (hs_read24(ctx, &lim) != 0)
            hs_fail(eng, BR_ERR_BAD_PARAM);
        return 0;
    }

    hs_x509_start_chain(eng, (uint32_t)by_client);

    uint32_t chain_len = hs_read24(ctx, &lim);
    uint32_t chain_outer, chain_inner;
    hs_open_elt(ctx, lim, chain_len, &chain_outer, &chain_inner);
    lim = chain_outer;

    while (chain_inner > 0) {
        uint32_t cert_len = hs_read24(ctx, &chain_inner);
        uint32_t cert_outer, cert_inner;
        hs_open_elt(ctx, chain_inner, cert_len, &cert_outer, &cert_inner);
        chain_inner = cert_outer;

        hs_x509_start_cert(eng, cert_len);

        while (cert_inner > 0) {
            uint32_t chunk = cert_inner > 256 ? 256 : cert_inner;
            hs_read_blob(ctx, &cert_inner,
                (uint32_t)offsetof(br_ssl_engine_context, pad), chunk);
            hs_x509_append(eng, (size_t)chunk);
        }

        hs_close_elt(ctx, cert_inner);
        hs_x509_end_cert(eng);
    }

    hs_close_elt(ctx, chain_inner);
    hs_close_elt(ctx, lim);

    uint32_t err = hs_x509_end_chain(eng);
    if (err) return (uint32_t)(-(int32_t)err);  /* neg: 오류 코드를 음수로 */

    return hs_get_key_type_usages(eng);
}

#endif /* SSL_HS_COMMON_T0_H */
