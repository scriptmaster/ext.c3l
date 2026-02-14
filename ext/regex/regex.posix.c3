// regex.posix.c3

module ext::regex @if(!env::WIN32);

import std::collections::list;

import regex;
alias cregex = module regex;

struct RegEx {
    String str;
    cregex::RegEx reg;
    cregex::RegMatch[20] m;
}

faultdef
    NO_MATCH,
    COMPILE_ERROR,
    INVALID_REGEX,
    RANGE_ERROR,
    OUT_OF_MEMORY,
    INVALID_COLLATION,
    INVALID_CHAR_CLASS,
    TRAILING_BACKSLASH,
    INVALID_BACKREFERENCE,
    UNMATCHED_BRACKET,
    UNMATCHED_PAREN,
    UNMATCHED_BRACE,
    INVALID_RANGE,
    INVALID_REPT_OPERATOR,
    GENERAL_ERROR;

fn fault err_fault(int err) @private
{
    switch (err) {
        case cregex::REG_NOMATCH:    return NO_MATCH;
        case cregex::REG_BADPAT:     return INVALID_REGEX;
        case cregex::REG_ECOLLATE:   return INVALID_COLLATION;
        case cregex::REG_ECTYPE:     return INVALID_CHAR_CLASS;
        case cregex::REG_EESCAPE:    return TRAILING_BACKSLASH;
        case cregex::REG_ESUBREG:    return INVALID_BACKREFERENCE;
        case cregex::REG_EBRACK:     return UNMATCHED_BRACKET;
        case cregex::REG_EPAREN:     return UNMATCHED_PAREN;
        case cregex::REG_EBRACE:     return UNMATCHED_BRACE;
        case cregex::REG_BADBR:      return INVALID_RANGE;
        case cregex::REG_ERANGE:     return RANGE_ERROR;
        case cregex::REG_ESPACE:     return OUT_OF_MEMORY;
        case cregex::REG_BADRPT: return INVALID_REPT_OPERATOR; 
    }
    return GENERAL_ERROR;
}

fn RegEx*? compile(Allocator allocx, String expr, bool case_sensitive = true) 
{
    RegEx* reg = allocator::alloc(allocx, RegEx);
    defer (catch err) { free(reg); }
    
    int flags = cregex::REG_EXTENDED;
    if (! case_sensitive) flags |= cregex::REG_ICASE;
    
    ZString zexpr = expr.zstr_tcopy();
    defer free(zexpr);
    int err = cregex::regcomp(&reg.reg, (char*)zexpr, flags);
    if (err != 0) {
        return err_fault(err)~;
    }
    return reg;
}

fn bool? RegEx.match(&self, String str, int* start, int* len)
{
    self.str = str;
    
    ZString zstr = str.zstr_tcopy();
    defer free(zstr);

    int err = cregex::regexec(&self.reg, (char*)zstr, self.m.len, &self.m, 0);
    
    if (err != 0) {
        if (err == cregex::REG_NOMATCH) return false;
        return err_fault(err)~;
    }
    
    *start = self.m[0].rm_so;
    *len = self.m[0].rm_eo - *start;
 
    return true;    
}

fn String? RegEx.group(&self, int idx)
{
    if (idx < 0 || idx >= self.m.len) return INVALID_RANGE~;
    if (self.m[idx].rm_so == -1) return NO_MATCH~;
    
    isz start = (isz)self.m[idx].rm_so;
    isz end = (isz)self.m[idx].rm_eo;
   
    if (end <= start) return ""; 
    return self.str[start..end-1];
}

fn String RegEx.replace(&self, Allocator allocx, String str, String sub, int n = 0)
{
    DString result;
    result.init(allocx);
    
    ZString zstr = str.zstr_tcopy();
    defer free(zstr);
    
    int i = 0;
    isz pos = 0;
    cregex::RegMatch match;
    while (cregex::regexec(&self.reg, (char*)zstr + pos, 1, &match, 0) == 0) {
        if (match.rm_so < 0) break;
        if (match.rm_so > 0) {
            result.append(str[pos..pos+(isz)match.rm_so-1]);
        }
        result.append(sub);
        
        pos += (isz)match.rm_eo;
        if (match.rm_eo == 0) break;
        i++;
        if (n > 0 && i >= n) break;
    }

    if (pos < str.len) {
        result.append(str[pos..]);
    }
    
    return result.str_view();
}

fn String[] RegEx.split(&self, Allocator allocx, String str, int n = 0)
{
    List{String} result;
    result.init(allocx);
    defer result.free();
    
    ZString zstr = str.zstr_tcopy();
    defer free(zstr);

    int i = 0; 
    isz pos = 0;
    cregex::RegMatch match;
    while (cregex::regexec(&self.reg, (char*)zstr + pos, 1, &match, 0) == 0) {
        if (match.rm_so < 0) break;
        if (match.rm_so > 0) {
            result.push(str[pos..pos+(isz)match.rm_so-1]);
        }
        pos += (isz)match.rm_eo;
        if (match.rm_eo == 0) break;
        i++;
        if (n > 0 && i >= n) break;
    }

    if (pos < str.len) {
        result.push(str[pos..]);
    }
    
    return result.to_array(allocx);
}

fn void RegEx.free(&self)
{
    cregex::regfree(&self.reg);
    free(self);
}

fn bool? reg_match(String str, String expr, int* start, int* len, bool case_sensitive=true)
{
    RegEx* reg = compile(tmem, expr, case_sensitive)!; // temp allocator
    defer reg.free();
    return reg.match(str, start, end);
}

fn String? reg_replace(Allocator allocx, String str, String expr, String sub, int n = 0, bool case_sensitive=true)
{
    RegEx* reg = compile(tmem, expr, case_sensitive)!; // temp allocator
    defer reg.free();
    return reg.replace(allocx, str, sub, n);
}

fn String[]? reg_split(Allocator allocx, String str, String expr, int n = 0, bool case_sensitive=true)
{
    RegEx* reg = compile(tmem, expr, case_sensitive)!; // temp allocator
    defer reg.free();
    return reg.split(allocx, str, n);
}

