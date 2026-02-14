// regex.win32.c3

module ext::regex @if(env::WIN32);

import std::collections::list;
import slre;

struct RegEx {
    // String pattern;
    slre::RegexInfo info;
    slre::SlreCap[20] caps;
    // bool case_sensitive;
    String str;
}

faultdef
    NO_MATCH,
    UNEXPECTED_QUANTIFIER,
    UNBALANCED_BRACKETS,
    INTERNAL_ERROR,
    INVALID_CHARACTER_SET,
    INVALID_METACHARACTER,
    CAPS_ARRAY_TOO_SMALL,
    TOO_MANY_BRANCHES,
    TOO_MANY_BRACKETS,
    GENERAL_ERROR;

fn fault err_fault(int err) @private
{
    switch (err) {
        case slre::NO_MATCH:              return NO_MATCH;
        case slre::UNEXPECTED_QUANTIFIER: return UNEXPECTED_QUANTIFIER;
        case slre::UNBALANCED_BRACKETS:   return UNBALANCED_BRACKETS;
        case slre::INTERNAL_ERROR:        return INTERNAL_ERROR;
        case slre::INVALID_CHARACTER_SET: return INVALID_CHARACTER_SET;
        case slre::INVALID_METACHARACTER: return INVALID_METACHARACTER;
        case slre::CAPS_ARRAY_TOO_SMALL:  return CAPS_ARRAY_TOO_SMALL;
        case slre::TOO_MANY_BRANCHES:     return TOO_MANY_BRANCHES;
        case slre::TOO_MANY_BRACKETS:     return TOO_MANY_BRACKETS;
    }
    return GENERAL_ERROR;
}

fn RegEx*? compile(Allocator allocx, String expr, bool case_sensitive = true) 
{
    RegEx* reg = allocator::alloc(allocx, RegEx);
    // reg.pattern = expr;
    // reg.case_sensitive = case_sensitive;
    
    // Initialize RegexInfo
    reg.info.flags = case_sensitive ? 0 : slre::IGNORE_CASE;
    reg.info.num_brackets = 0;
    reg.info.num_branches = 0;
    reg.info.num_caps = (int)reg.caps.len;
    reg.info.caps = &reg.caps;
    
    // Compile the regex
    ZString zexpr = expr.zstr_tcopy();
    defer free(zexpr);
    
    int err = slre::compile((char*)zexpr, (int)expr.len, &reg.info);
    if (err < 0) {
        free(reg);
        return err_fault(err)~;
    }
    
    return reg;
}

fn bool? RegEx.match(&self, String str, int* start, int* len)
{
    self.last_str = str;
    
    ZString zstr = str.zstr_tcopy();
    defer free(zstr);
    
    int result = slre::match((char*)zstr, (int)str.len, &self.info);
    
    if (result < 0) {
        if (result == slre::NO_MATCH) return false;
        return err_fault(result)~;
    }
    
    *start = self.caps[0].ptr-(char*)zstr;
    *len = self.caps[0].len;
    
    return true;    
}

fn String? RegEx.group(&self, int idx)
{
    if (idx < 0 || idx >= self.caps.len) return RANGE_ERROR~;
    
    if (idx >= self.caps.len) return RANGE_ERROR~;
    if (self.caps[idx].ptr == null) return NO_MATCH~;
    
    return (String) self.caps[idx].ptr[0: self.caps[idx].len];
}

fn String RegEx.replace(&self, Allocator allocx, String str, String sub, int n = 0)
{
    DString result;
    result.init(allocx);
    
    ZString zstr = str.zstr_tcopy();
    defer free(zstr);
    
    char* current = (char*)zstr;
    isz pos = 0;
    int count = 0;
    
    while (pos < str.len) {
        // Match from current position
        int remaining = (int)(str.len - pos);
        int match_result = slre::match(current, remaining, &self.info);
        
        if (match_result < 0) {
            // No more matches, append the rest
            result.append(str[pos..]);
            break;
        }
        
        // Get the first capture (index 0) which contains the matched text
        slre::SlreCap* cap = &self.info.caps[0];
        
        // Append text before match
        if (cap.ptr != null && cap.ptr > current) {
            isz pre_len = (isz)(cap.ptr - current);
            result.append(str[pos..pos + pre_len - 1]);
            pos += pre_len;
        }
        
        // Append replacement
        result.append(sub);
        
        // Move past the match
        if (cap.len > 0) {
            pos += (isz)cap.len;
            current = (char*)zstr + pos;
        } else {
            // Zero-length match, advance by 1 to avoid infinite loop
            if (pos < str.len) {
                result.append_char(str[pos]);
                pos++;
                current++;
            } else {
                break;
            }
        }
        
        count++;
        if (n > 0 && count >= n) {
            // Append the rest
            if (pos < str.len) {
                result.append(str[pos..]);
            }
            break;
        }
    }
    
    return result.str_view();
}

fn String[] RegEx.split(&self, Allocator allocx, String str, int n = 0)
{
    List(<String>) result;
    result.init(allocx);
    defer result.free();
    
    ZString zstr = str.zstr_tcopy();
    defer free(zstr);
    
    char* current = (char*)zstr;
    isz pos = 0;
    int count = 0;
    
    while (pos < str.len) {
        // Match from current position
        int remaining = (int)(str.len - pos);
        int match_result = slre::match(current, remaining, &self.info);
        
        if (match_result < 0) {
            // No more matches, add the rest
            result.push(str[pos..]);
            break;
        }
        
        // Get the first capture (index 0) which contains the matched text
        slre::SlreCap* cap = &self.info.caps[0];
        
        // Add text before match
        if (cap.ptr != null) {
            isz match_start = pos + (isz)(cap.ptr - current);
            if (match_start > pos) {
                result.push(str[pos..match_start - 1]);
            } else {
                // Empty string before match
                result.push("");
            }
            
            // Move past the match
            pos = match_start + (isz)cap.len;
            current = (char*)zstr + pos;
            
            // Avoid infinite loop on zero-length match
            if (cap.len == 0 && pos < str.len) {
                pos++;
                current++;
            }
        } else {
            break;
        }
        
        count++;
        if (n > 0 && count >= n) {
            if (pos < str.len) {
                result.push(str[pos..]);
            }
            break;
        }
    }
    
    // If no matches were found, return the original string as single element
    if (result.len() == 0) {
        result.push(str);
    }
    
    return result.to_array(allocx);
}

fn void RegEx.free(&self)
{
    free(self);
}

fn bool? reg_match(String str, String expr, bool case_sensitive=true)
{
    RegEx* reg = compile(tmem, expr, case_sensitive)!; // temp allocator
    defer reg.free();
    return reg.match(str);
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
