/*
 * ssl_hs_common_cc.h
 *
 * C translation of all cc: words from ssl_hs_common.t0.
 *
 * Transformation rules
 * --------------------
 * T0 원문에서 각 cc: 단어는 T0_POP/T0_PUSH 매크로로 VM 스택을 조작한다.
 * C 함수로 옮길 때의 규칙:
 *
 *   T0 스택 입력  ( a b -- )   → 함수 파라미터  (a 먼저, b 나중 = TOS)
 *   T0 스택 출력  ( -- x )     → return 값
 *   T0 스택 출력  ( -- x y )   → 출력 포인터 파라미터 (x 먼저, y 나중)
 *   ENG 매크로                 → br_ssl_engine_context *eng 파라미터로 교체
 *   T0_CO()                   → hs_co(ctx) 호출 (3단계에서 구현)
 *   T0_RET()                  → return (early return)
 *
 * 'addr-eng:', 'addr-session-field:', 'err:' 는 컴파일 타임 전용 메타워드이므로
 * 런타임 함수가 아니다. 대신 해당 필드의 offsetof 값을 직접 사용한다.
 */

#ifndef SSL_HS_COMMON_CC_H
#define SSL_HS_COMMON_CC_H

#include <stddef.h>
#include <stdint.h>
#include <string.h>
#include <stdio.h>
#include "inner.h"   /* br_ssl_engine_context, BearSSL internals */

extern const unsigned char t0_datablock[];

/* ======================================================================
 * addr-eng: 매크로 대체
 *
 * T0 원문:
 *   addr-eng: foo   →   "addr-foo"라는 단어가 offsetof(br_ssl_engine_context, foo)를 push
 *
 * C에서는 offsetof를 직접 사용하거나, 아래 헬퍼 인라인으로 필드 포인터를 얻는다.
 * ====================================================================== */

/* 엔진 컨텍스트 내 임의 오프셋에서 uint8_t 읽기 */
static inline uint8_t
eng_get8(const br_ssl_engine_context *eng, size_t off)
{
    return *((const unsigned char *)eng + off);
}

/* 엔진 컨텍스트 내 임의 오프셋에서 uint16_t 읽기 */
static inline uint16_t
eng_get16(const br_ssl_engine_context *eng, size_t off)
{
    return *(const uint16_t *)(const void *)((const unsigned char *)eng + off);
}

/* 엔진 컨텍스트 내 임의 오프셋에서 uint32_t 읽기 */
static inline uint32_t
eng_get32(const br_ssl_engine_context *eng, size_t off)
{
    return *(const uint32_t *)(const void *)((const unsigned char *)eng + off);
}

/* 엔진 컨텍스트 내 임의 오프셋에 uint8_t 쓰기 */
static inline void
eng_set8(br_ssl_engine_context *eng, size_t off, uint8_t val)
{
    *((unsigned char *)eng + off) = val;
}

/* 엔진 컨텍스트 내 임의 오프셋에 uint16_t 쓰기 */
static inline void
eng_set16(br_ssl_engine_context *eng, size_t off, uint16_t val)
{
    *(uint16_t *)(void *)((unsigned char *)eng + off) = val;
}

/* 엔진 컨텍스트 내 임의 오프셋에 uint32_t 쓰기 */
static inline void
eng_set32(br_ssl_engine_context *eng, size_t off, uint32_t val)
{
    *(uint32_t *)(void *)((unsigned char *)eng + off) = val;
}

/* ======================================================================
 * cc: DBG ( addr -- )
 *
 * T0 원문:
 *   fprintf(stderr, "%s\n", &t0_datablock[T0_POPi()]);
 *
 * 데이터 블록의 오프셋 addr에 있는 NUL 종료 문자열을 stderr에 출력한다.
 * ====================================================================== */
static inline void
hs_DBG(size_t addr)
{
    fprintf(stderr, "%s\n", (const char *)&t0_datablock[addr]);
}

/* ======================================================================
 * cc: DBG2 ( addr x -- )
 *
 * T0 원문:
 *   int32_t x = T0_POPi();
 *   fprintf(stderr, "%s: %ld (0x%08lX)\n", &t0_datablock[T0_POPi()], ...);
 *
 * 문자열과 정수 값을 같이 출력한다.
 * ====================================================================== */
static inline void
hs_DBG2(size_t addr, int32_t x)
{
    fprintf(stderr, "%s: %ld (0x%08lX)\n",
        (const char *)&t0_datablock[addr],
        (long)x,
        (unsigned long)(uint32_t)x);
}

/* ======================================================================
 * cc: fail ( err -- ! )
 *
 * T0 원문:
 *   br_ssl_engine_fail(ENG, (int)T0_POPi());
 *   T0_CO();
 *
 * 엔진을 오류 상태로 만들고 즉시 caller에게 제어를 반환한다.
 * T0_CO()는 VM에서 goto t0_exit 이다. C에서는 hs_co()를 호출한다.
 * hs_co()는 3단계(코루틴 인프라)에서 정의된다.
 *
 * '! '는 Forth에서 이 단어가 절대 반환하지 않음을 뜻한다.
 * C에서는 noreturn을 붙이기 어려우므로 호출자가 이후 코드를 쓰지 않는 것으로 약속한다.
 * ====================================================================== */
/* 전방 선언: hs_co는 3단계에서 구현된다. */
void hs_co(br_ssl_engine_context *eng);

static inline void
hs_fail(br_ssl_engine_context *eng, int err)
{
    br_ssl_engine_fail(eng, err);
    hs_co(eng);   /* T0_CO() 대응: 제어를 caller에게 반환 */
}

/* ======================================================================
 * cc: get8  ( addr -- val )
 * cc: get16 ( addr -- val )
 * cc: get32 ( addr -- val )
 * cc: set8  ( val addr -- )
 * cc: set16 ( val addr -- )
 * cc: set32 ( val addr -- )
 *
 * T0 원문:
 *   size_t addr = (size_t)T0_POP();
 *   T0_PUSH(*((unsigned char *)ENG + addr));   // get8
 *
 * 엔진 컨텍스트 구조체를 바이트 배열로 보고 임의 오프셋을 읽거나 쓴다.
 * addr-eng:, addr-session-field: 워드가 생성하는 오프셋 값과 함께 사용된다.
 *
 * eng_get*/eng_set* 인라인과 동일한 기능이다.
 * T0 스택 시그니처를 그대로 이름에 반영하기 위해 별칭을 제공한다.
 * ====================================================================== */

#define hs_get8(eng, addr)        eng_get8((eng), (addr))
#define hs_get16(eng, addr)       eng_get16((eng), (addr))
#define hs_get32(eng, addr)       eng_get32((eng), (addr))
#define hs_set8(eng, val, addr)   eng_set8((eng), (addr), (uint8_t)(val))
#define hs_set16(eng, val, addr)  eng_set16((eng), (addr), (uint16_t)(val))
#define hs_set32(eng, val, addr)  eng_set32((eng), (addr), (uint32_t)(val))

/* ======================================================================
 * cc: supported-curves ( -- x )
 *
 * T0 원문:
 *   uint32_t x = ENG->iec == NULL ? 0 : ENG->iec->supported_curves;
 *   T0_PUSH(x);
 *
 * EC 구현체가 없으면 0, 있으면 지원하는 커브의 비트마스크를 반환한다.
 * ====================================================================== */
static inline uint32_t
hs_supported_curves(const br_ssl_engine_context *eng)
{
    return eng->iec == NULL ? 0 : eng->iec->supported_curves;
}

/* ======================================================================
 * cc: supported-hash-functions ( -- x num )
 *
 * T0 원문:
 *   for (i = br_sha1_ID; i <= br_sha512_ID; i++) {
 *       if (br_multihash_getimpl(&ENG->mhash, i)) {
 *           x |= 1U << i;
 *           num++;
 *       }
 *   }
 *   T0_PUSH(x);
 *   T0_PUSH(num);
 *
 * 두 값을 반환하므로 출력 포인터를 사용한다.
 * MD5(id=1)는 의도적으로 건너뛴다(SHA-1부터 시작).
 * ====================================================================== */
static inline void
hs_supported_hash_functions(const br_ssl_engine_context *eng,
    uint32_t *out_x, uint32_t *out_num)
{
    int i;
    unsigned x = 0, num = 0;

    for (i = br_sha1_ID; i <= br_sha512_ID; i++) {
        if (br_multihash_getimpl(&eng->mhash, i)) {
            x   |= 1U << i;
            num ++;
        }
    }
    *out_x   = x;
    *out_num = num;
}

/* ======================================================================
 * cc: supports-rsa-sign? ( -- bool )
 * cc: supports-ecdsa?    ( -- bool )
 *
 * T0 원문:
 *   T0_PUSHi(-(ENG->irsavrfy != 0));
 *   T0_PUSHi(-(ENG->iecdsa   != 0));
 *
 * T0 불리언 규칙: true = -1 (0xFFFFFFFF), false = 0
 * ====================================================================== */
static inline int
hs_supports_rsa_sign(const br_ssl_engine_context *eng)
{
    return eng->irsavrfy != NULL ? -1 : 0;
}

static inline int
hs_supports_ecdsa(const br_ssl_engine_context *eng)
{
    return eng->iecdsa != NULL ? -1 : 0;
}

/* ======================================================================
 * cc: multihash-init ( -- )
 *
 * T0 원문:
 *   br_multihash_init(&ENG->mhash);
 *
 * 핸드셰이크 시작 시 다중 해시 컨텍스트를 초기화한다.
 * ====================================================================== */
static inline void
hs_multihash_init(br_ssl_engine_context *eng)
{
    br_multihash_init(&eng->mhash);
}

/* ======================================================================
 * cc: flush-record ( -- )
 *
 * T0 원문:
 *   br_ssl_engine_flush_record(ENG);
 *
 * 누적된 출력 페이로드가 있으면 레코드를 닫고 전송 스케줄에 올린다.
 * 페이로드가 없으면 아무 일도 하지 않는다.
 * ====================================================================== */
static inline void
hs_flush_record(br_ssl_engine_context *eng)
{
    br_ssl_engine_flush_record(eng);
}

/* ======================================================================
 * cc: payload-to-send? ( -- bool )
 *
 * T0 원문:
 *   T0_PUSHi(-br_ssl_engine_has_pld_to_send(ENG));
 * ====================================================================== */
static inline int
hs_payload_to_send(const br_ssl_engine_context *eng)
{
    return -br_ssl_engine_has_pld_to_send(eng);
}

/* ======================================================================
 * cc: has-input? ( -- bool )
 *
 * T0 원문:
 *   T0_PUSHi(-(ENG->hlen_in != 0));
 *
 * 현재 레코드에 읽을 수 있는 바이트가 있으면 true(-1).
 * ====================================================================== */
static inline int
hs_has_input(const br_ssl_engine_context *eng)
{
    return eng->hlen_in != 0 ? -1 : 0;
}

/* ======================================================================
 * cc: can-output? ( -- bool )
 *
 * T0 원문:
 *   T0_PUSHi(-(ENG->hlen_out > 0));
 *
 * 출력 버퍼에 쓸 공간이 있으면 true(-1).
 * ====================================================================== */
static inline int
hs_can_output(const br_ssl_engine_context *eng)
{
    return eng->hlen_out > 0 ? -1 : 0;
}

/* ======================================================================
 * cc: discard-input ( -- )
 *
 * T0 원문:
 *   ENG->hlen_in = 0;
 *
 * 현재 입력 레코드 전체를 버린다.
 * ====================================================================== */
static inline void
hs_discard_input(br_ssl_engine_context *eng)
{
    eng->hlen_in = 0;
}

/* ======================================================================
 * cc: read8-native ( -- x )
 *
 * T0 원문:
 *   if (ENG->hlen_in > 0) {
 *       unsigned char x = *ENG->hbuf_in++;
 *       if (ENG->record_type_in == BR_SSL_HANDSHAKE)
 *           br_multihash_update(&ENG->mhash, &x, 1);
 *       T0_PUSH(x);
 *       ENG->hlen_in--;
 *   } else {
 *       T0_PUSHi(-1);
 *   }
 *
 * 즉시 읽을 수 있는 바이트가 없으면 -1을 반환한다.
 * 핸드셰이크 레코드라면 읽은 바이트를 멀티해서에 주입한다.
 * ====================================================================== */
static inline int
hs_read8_native(br_ssl_engine_context *eng)
{
    if (eng->hlen_in > 0) {
        unsigned char x = *eng->hbuf_in++;
        if (eng->record_type_in == BR_SSL_HANDSHAKE) {
            br_multihash_update(&eng->mhash, &x, 1);
        }
        eng->hlen_in--;
        return (int)(unsigned int)x;
    }
    return -1;
}

/* ======================================================================
 * cc: read-chunk-native ( addr len -- addr len )
 *
 * T0 원문:
 *   size_t clen = ENG->hlen_in;
 *   if (clen > 0) {
 *       memcpy((unsigned char *)ENG + addr, ENG->hbuf_in, clen);
 *       ...
 *       T0_PUSH(addr + clen);
 *       T0_PUSH(len - clen);
 *   }
 *
 * 현재 버퍼에서 최대 len 바이트를 엔진 컨텍스트의 addr 오프셋으로 복사한다.
 * 실제로 읽은 바이트 수만큼 addr을 전진하고, len을 감소시킨다.
 * 읽을 바이트가 없으면 addr/len을 변경하지 않는다.
 * ====================================================================== */
static inline void
hs_read_chunk_native(br_ssl_engine_context *eng,
    uint32_t *io_addr, uint32_t *io_len)
{
    size_t clen = eng->hlen_in;

    if (clen == 0) return;

    if ((size_t)*io_len < clen) {
        clen = (size_t)*io_len;
    }
    memcpy((unsigned char *)eng + *io_addr, eng->hbuf_in, clen);
    if (eng->record_type_in == BR_SSL_HANDSHAKE) {
        br_multihash_update(&eng->mhash, eng->hbuf_in, clen);
    }
    eng->hbuf_in  += clen;
    eng->hlen_in  -= clen;
    *io_addr += (uint32_t)clen;
    *io_len  -= (uint32_t)clen;
}

/* ======================================================================
 * cc: more-incoming-bytes? ( -- bool )
 *
 * T0 원문:
 *   T0_PUSHi(ENG->hlen_in != 0 || !br_ssl_engine_recvrec_finished(ENG));
 *
 * 현재 레코드에 아직 오지 않은 바이트가 있으면 true.
 * ====================================================================== */
static inline int
hs_more_incoming_bytes(const br_ssl_engine_context *eng)
{
    return (eng->hlen_in != 0 || !br_ssl_engine_recvrec_finished(eng))
           ? -1 : 0;
}

/* ======================================================================
 * cc: write8-native ( x -- bool )
 *
 * T0 원문:
 *   unsigned char x = (unsigned char)T0_POP();
 *   if (ENG->hlen_out > 0) {
 *       if (ENG->record_type_out == BR_SSL_HANDSHAKE)
 *           br_multihash_update(&ENG->mhash, &x, 1);
 *       *ENG->hbuf_out++ = x;
 *       ENG->hlen_out--;
 *       T0_PUSHi(-1);
 *   } else {
 *       T0_PUSHi(0);
 *   }
 *
 * 출력 버퍼에 공간이 있으면 1바이트를 쓰고 -1을 반환, 없으면 0을 반환.
 * ====================================================================== */
static inline int
hs_write8_native(br_ssl_engine_context *eng, unsigned char x)
{
    if (eng->hlen_out > 0) {
        if (eng->record_type_out == BR_SSL_HANDSHAKE) {
            br_multihash_update(&eng->mhash, &x, 1);
        }
        *eng->hbuf_out++ = x;
        eng->hlen_out--;
        return -1;
    }
    return 0;
}

/* ======================================================================
 * cc: write-blob-chunk ( addr len -- addr len )
 *
 * T0 원문:
 *   size_t clen = ENG->hlen_out;
 *   if (clen > 0) {
 *       memcpy(ENG->hbuf_out, (unsigned char *)ENG + addr, clen);
 *       ...
 *       T0_PUSH(addr + clen);
 *       T0_PUSH(len - clen);
 *   }
 *
 * read-chunk-native의 반대 방향. 엔진 컨텍스트의 addr 오프셋에서
 * 출력 버퍼로 최대 len 바이트를 복사한다.
 * ====================================================================== */
static inline void
hs_write_blob_chunk(br_ssl_engine_context *eng,
    uint32_t *io_addr, uint32_t *io_len)
{
    size_t clen = eng->hlen_out;

    if (clen == 0) return;

    if ((size_t)*io_len < clen) {
        clen = (size_t)*io_len;
    }
    memcpy(eng->hbuf_out, (unsigned char *)eng + *io_addr, clen);
    if (eng->record_type_out == BR_SSL_HANDSHAKE) {
        br_multihash_update(&eng->mhash, eng->hbuf_out, clen);
    }
    eng->hbuf_out += clen;
    eng->hlen_out -= clen;
    *io_addr += (uint32_t)clen;
    *io_len  -= (uint32_t)clen;
}

/* ======================================================================
 * cc: memcmp ( addr1 addr2 len -- bool )
 *
 * T0 원문:
 *   void *addr2 = (unsigned char *)ENG + T0_POP();
 *   void *addr1 = (unsigned char *)ENG + T0_POP();
 *   T0_PUSH((uint32_t)-(memcmp(addr1, addr2, len) == 0));
 *
 * 두 오프셋이 가리키는 버퍼를 비교. 같으면 -1(true), 다르면 0(false).
 * ====================================================================== */
static inline int
hs_memcmp(const br_ssl_engine_context *eng,
    size_t addr1, size_t addr2, size_t len)
{
    const void *p1 = (const unsigned char *)eng + addr1;
    const void *p2 = (const unsigned char *)eng + addr2;
    return memcmp(p1, p2, len) == 0 ? -1 : 0;
}

/* ======================================================================
 * cc: memcpy ( dst src len -- )
 *
 * T0 원문:
 *   memcpy((unsigned char *)ENG + dst, (unsigned char *)ENG + src, len);
 *
 * 엔진 컨텍스트 내부의 두 오프셋 사이에서 바이트를 복사한다.
 * ====================================================================== */
static inline void
hs_memcpy(br_ssl_engine_context *eng,
    size_t dst, size_t src, size_t len)
{
    memcpy((unsigned char *)eng + dst,
           (const unsigned char *)eng + src,
           len);
}

/* ======================================================================
 * cc: strlen ( str -- len )
 *
 * T0 원문:
 *   void *str = (unsigned char *)ENG + T0_POP();
 *   T0_PUSH((uint32_t)strlen(str));
 *
 * 엔진 컨텍스트 내 오프셋에 있는 NUL 종료 문자열의 길이를 반환한다.
 * ====================================================================== */
static inline uint32_t
hs_strlen(const br_ssl_engine_context *eng, size_t off)
{
    return (uint32_t)strlen((const char *)((const unsigned char *)eng + off));
}

/* ======================================================================
 * cc: bzero ( addr len -- )
 *
 * T0 원문:
 *   memset((unsigned char *)ENG + addr, 0, len);
 * ====================================================================== */
static inline void
hs_bzero(br_ssl_engine_context *eng, size_t addr, size_t len)
{
    memset((unsigned char *)eng + addr, 0, len);
}

/* ======================================================================
 * cc: mkrand ( addr len -- )
 *
 * T0 원문:
 *   br_hmac_drbg_generate(&ENG->rng, (unsigned char *)ENG + addr, len);
 *
 * HMAC-DRBG로 임의의 바이트를 엔진 컨텍스트의 addr 오프셋에 생성한다.
 * ====================================================================== */
static inline void
hs_mkrand(br_ssl_engine_context *eng, size_t addr, size_t len)
{
    br_hmac_drbg_generate(&eng->rng, (unsigned char *)eng + addr, len);
}

/* ======================================================================
 * cc: total-chain-length ( -- len )
 *
 * T0 원문:
 *   uint32_t total = 0;
 *   for (u = 0; u < ENG->chain_len; u++)
 *       total += 3 + (uint32_t)ENG->chain[u].data_len;
 *   T0_PUSH(total);
 *
 * 인증서 체인 전체의 바이트 길이를 계산한다.
 * 각 인증서는 3바이트 길이 헤더 + 데이터로 구성된다.
 * 체인 전체 헤더(3바이트)는 포함하지 않는다.
 * ====================================================================== */
static inline uint32_t
hs_total_chain_length(const br_ssl_engine_context *eng)
{
    size_t u;
    uint32_t total = 0;

    for (u = 0; u < eng->chain_len; u++) {
        total += 3 + (uint32_t)eng->chain[u].data_len;
    }
    return total;
}

/* ======================================================================
 * cc: begin-cert ( -- len )
 *
 * T0 원문:
 *   if (ENG->chain_len == 0) {
 *       T0_PUSHi(-1);
 *   } else {
 *       ENG->cert_cur = ENG->chain->data;
 *       ENG->cert_len = ENG->chain->data_len;
 *       ENG->chain++;
 *       ENG->chain_len--;
 *       T0_PUSH(ENG->cert_len);
 *   }
 *
 * 체인에서 다음 인증서를 꺼낸다. 체인이 비어 있으면 -1을 반환한다.
 * ====================================================================== */
static inline int32_t
hs_begin_cert(br_ssl_engine_context *eng)
{
    if (eng->chain_len == 0) {
        return -1;
    }
    eng->cert_cur  = eng->chain->data;
    eng->cert_len  = eng->chain->data_len;
    eng->chain    ++;
    eng->chain_len--;
    return (int32_t)eng->cert_len;
}

/* ======================================================================
 * cc: copy-cert-chunk ( -- len )
 *
 * T0 원문:
 *   clen = ENG->cert_len;
 *   if (clen > sizeof ENG->pad) clen = sizeof ENG->pad;
 *   memcpy(ENG->pad, ENG->cert_cur, clen);
 *   ENG->cert_cur += clen;
 *   ENG->cert_len -= clen;
 *   T0_PUSH(clen);
 *
 * 현재 인증서 데이터를 pad 버퍼 크기 단위로 복사한다.
 * 0을 반환하면 해당 인증서 복사가 완료된 것이다.
 * ====================================================================== */
static inline size_t
hs_copy_cert_chunk(br_ssl_engine_context *eng)
{
    size_t clen = eng->cert_len;

    if (clen > sizeof eng->pad) {
        clen = sizeof eng->pad;
    }
    memcpy(eng->pad, eng->cert_cur, clen);
    eng->cert_cur += clen;
    eng->cert_len -= clen;
    return clen;
}

/* ======================================================================
 * cc: x509-start-chain ( by_client -- )
 * cc: x509-start-cert  ( length -- )
 * cc: x509-append      ( length -- )
 * cc: x509-end-cert    ( -- )
 * cc: x509-end-chain   ( -- err )
 * cc: get-key-type-usages ( -- key-type-usages )
 *
 * X.509 인증서 체인 처리 vtable 호출 래퍼.
 * ====================================================================== */

/* T0 원문:
 *   xc->start_chain(ENG->x509ctx, bc ? ENG->server_name : NULL);
 * by_client가 참이면 서버 이름 검증 없이 체인을 시작한다. */
static inline void
hs_x509_start_chain(br_ssl_engine_context *eng, uint32_t by_client)
{
    const br_x509_class *xc = *(eng->x509ctx);
    xc->start_chain(eng->x509ctx, by_client ? eng->server_name : NULL);
}

/* T0 원문:
 *   xc->start_cert(ENG->x509ctx, T0_POP()); */
static inline void
hs_x509_start_cert(br_ssl_engine_context *eng, uint32_t length)
{
    const br_x509_class *xc = *(eng->x509ctx);
    xc->start_cert(eng->x509ctx, length);
}

/* T0 원문:
 *   xc->append(ENG->x509ctx, ENG->pad, len); */
static inline void
hs_x509_append(br_ssl_engine_context *eng, size_t len)
{
    const br_x509_class *xc = *(eng->x509ctx);
    xc->append(eng->x509ctx, eng->pad, len);
}

/* T0 원문:
 *   xc->end_cert(ENG->x509ctx); */
static inline void
hs_x509_end_cert(br_ssl_engine_context *eng)
{
    const br_x509_class *xc = *(eng->x509ctx);
    xc->end_cert(eng->x509ctx);
}

/* T0 원문:
 *   T0_PUSH(xc->end_chain(ENG->x509ctx));
 * 0이면 성공, 비-0이면 오류 코드. */
static inline uint32_t
hs_x509_end_chain(br_ssl_engine_context *eng)
{
    const br_x509_class *xc = *(eng->x509ctx);
    return xc->end_chain(eng->x509ctx);
}

/* T0 원문:
 *   pk = xc->get_pkey(ENG->x509ctx, &usages);
 *   T0_PUSH(pk == NULL ? 0 : pk->key_type | usages);
 * 키 타입과 허용된 사용처를 하나의 값으로 합쳐 반환한다. */
static inline uint32_t
hs_get_key_type_usages(br_ssl_engine_context *eng)
{
    const br_x509_class *xc = *(eng->x509ctx);
    const br_x509_pkey *pk;
    unsigned usages;

    pk = xc->get_pkey(eng->x509ctx, &usages);
    if (pk == NULL) return 0;
    return pk->key_type | usages;
}

/* ======================================================================
 * cc: copy-protocol-name ( idx -- len )
 *
 * T0 원문:
 *   size_t len = strlen(ENG->protocol_names[idx]);
 *   memcpy(ENG->pad, ENG->protocol_names[idx], len);
 *   T0_PUSH(len);
 *
 * 지정한 인덱스의 ALPN 프로토콜 이름을 pad 버퍼에 복사한다.
 * ====================================================================== */
static inline size_t
hs_copy_protocol_name(br_ssl_engine_context *eng, size_t idx)
{
    size_t len = strlen(eng->protocol_names[idx]);
    memcpy(eng->pad, eng->protocol_names[idx], len);
    return len;
}

/* ======================================================================
 * cc: test-protocol-name ( len -- n )
 *
 * T0 원문:
 *   for (u = 0; u < ENG->protocol_names_num; u++) {
 *       if (len == strlen(name) && memcmp(ENG->pad, name, len) == 0) {
 *           T0_PUSH(u);
 *           T0_RET();
 *       }
 *   }
 *   T0_PUSHi(-1);
 *
 * pad 버퍼의 내용을 설정된 ALPN 목록과 비교한다.
 * 일치하면 인덱스를, 없으면 -1을 반환한다.
 * ====================================================================== */
static inline int32_t
hs_test_protocol_name(const br_ssl_engine_context *eng, size_t len)
{
    size_t u;

    for (u = 0; u < eng->protocol_names_num; u++) {
        const char *name = eng->protocol_names[u];
        if (len == strlen(name) && memcmp(eng->pad, name, len) == 0) {
            return (int32_t)u;
        }
    }
    return -1;
}

/* ======================================================================
 * cc: switch-cbc-out / switch-cbc-in
 * cc: switch-aesgcm-out / switch-aesgcm-in
 * cc: switch-chapol-out / switch-chapol-in
 * cc: switch-aesccm-out / switch-aesccm-in
 *
 * 암호화 파라미터 전환 래퍼.
 * T0 스택에서 is_client가 가장 아래(먼저 push된 값)이므로
 * T0_POP() 순서와 함수 파라미터 순서가 역순임에 주의한다.
 * ====================================================================== */

/* T0 원문:
 *   cipher_key_len = T0_POP();
 *   aes            = T0_POP();
 *   mac_id         = T0_POP();
 *   prf_id         = T0_POP();
 *   is_client      = T0_POP();
 *   br_ssl_engine_switch_cbc_out(...); */
static inline void
hs_switch_cbc_out(br_ssl_engine_context *eng,
    int is_client, int prf_id, int mac_id,
    int aes, unsigned cipher_key_len)
{
    br_ssl_engine_switch_cbc_out(eng, is_client, prf_id, mac_id,
        aes ? eng->iaes_cbcenc : eng->ides_cbcenc,
        cipher_key_len);
}

static inline void
hs_switch_cbc_in(br_ssl_engine_context *eng,
    int is_client, int prf_id, int mac_id,
    int aes, unsigned cipher_key_len)
{
    br_ssl_engine_switch_cbc_in(eng, is_client, prf_id, mac_id,
        aes ? eng->iaes_cbcdec : eng->ides_cbcdec,
        cipher_key_len);
}

static inline void
hs_switch_aesgcm_out(br_ssl_engine_context *eng,
    int is_client, int prf_id, unsigned cipher_key_len)
{
    br_ssl_engine_switch_gcm_out(eng, is_client, prf_id,
        eng->iaes_ctr, cipher_key_len);
}

static inline void
hs_switch_aesgcm_in(br_ssl_engine_context *eng,
    int is_client, int prf_id, unsigned cipher_key_len)
{
    br_ssl_engine_switch_gcm_in(eng, is_client, prf_id,
        eng->iaes_ctr, cipher_key_len);
}

static inline void
hs_switch_chapol_out(br_ssl_engine_context *eng,
    int is_client, int prf_id)
{
    br_ssl_engine_switch_chapol_out(eng, is_client, prf_id);
}

static inline void
hs_switch_chapol_in(br_ssl_engine_context *eng,
    int is_client, int prf_id)
{
    br_ssl_engine_switch_chapol_in(eng, is_client, prf_id);
}

static inline void
hs_switch_aesccm_out(br_ssl_engine_context *eng,
    int is_client, int prf_id,
    unsigned cipher_key_len, unsigned tag_len)
{
    br_ssl_engine_switch_ccm_out(eng, is_client, prf_id,
        eng->iaes_ctrcbc, cipher_key_len, tag_len);
}

static inline void
hs_switch_aesccm_in(br_ssl_engine_context *eng,
    int is_client, int prf_id,
    unsigned cipher_key_len, unsigned tag_len)
{
    br_ssl_engine_switch_ccm_in(eng, is_client, prf_id,
        eng->iaes_ctrcbc, cipher_key_len, tag_len);
}

/* ======================================================================
 * cc: compute-Finished-inner ( from_client prf_id -- )
 *
 * T0 원문:
 *   int prf_id     = T0_POP();
 *   int from_client = T0_POPi();
 *   br_tls_prf_impl prf = br_ssl_engine_get_PRF(ENG, prf_id);
 *   ...
 *   prf(ENG->pad, 12, ENG->session.master_secret, ...,
 *       from_client ? "client finished" : "server finished", 1, &seed);
 *
 * Finished 메시지의 12바이트 검증값을 pad에 계산한다.
 * TLS 1.2+는 협상된 PRF 해시, 이전 버전은 MD5+SHA-1(36바이트)를 사용한다.
 * ====================================================================== */
static inline void
hs_compute_Finished_inner(br_ssl_engine_context *eng,
    int from_client, int prf_id)
{
    unsigned char tmp[48];
    br_tls_prf_seed_chunk seed;
    br_tls_prf_impl prf;

    prf = br_ssl_engine_get_PRF(eng, prf_id);
    seed.data = tmp;

    if (eng->session.version >= BR_TLS12) {
        seed.len = br_multihash_out(&eng->mhash, prf_id, tmp);
    } else {
        br_multihash_out(&eng->mhash, br_md5_ID,  tmp);
        br_multihash_out(&eng->mhash, br_sha1_ID, tmp + 16);
        seed.len = 36;
    }
    prf(eng->pad, 12,
        eng->session.master_secret, sizeof eng->session.master_secret,
        from_client ? "client finished" : "server finished",
        1, &seed);
}

#endif /* SSL_HS_COMMON_CC_H */
