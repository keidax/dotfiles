import re, vim

def get_scoped_vim_var(varname, default):
    """Checks for and returns the first of b:varname, g:varname, or default."""
    if vim.eval("exists('b:%s')" % varname) == '1':
        return vim.eval("b:%s" % varname)
    elif vim.eval("exists('g:%s')" % varname) == '1':
        return vim.eval("g:%s" % varname)
    else:
        return default

def ruby_quote(string=None):
    """
    Return a quote character in the configured ruby quote style. Intended for
    the tersest interpolation.
    """
    if string is None:
        return ruby_quote_standalone()

    return ruby_quote_infer(string)


def ruby_quote_standalone():
    """Return a quote character in the configured quote style."""
    if get_scoped_vim_var('ruby_double_quote', '0') != '0':
        return '"'
    else:
        return "'"


interp = re.compile('#\{.*\}')
def ruby_quote_infer(string):
    """
    If the passed string contains ruby interpolation, return a double quote
    character. Otherwise, return a quote character in the configured style.
    """
    if interp.search(string):
        return '"'
    else:
        return ruby_quote_standalone()


def ruby_quote_string(string):
    """
    Return the entire string surrounded by quotes in the configured style.
    Always use double quotes if it looks like an interpolated string.
    """

    quote = ruby_quote_infer(string)
    return quote + string + quote


# Recommended usage:
#
# from ruby_snippets import *
#
# def rq(string=None):
#     # Allow passing tabstop index
#     if isinstance(string, int):
#         string = t[string]
#     snip.rv = ruby_quote(string)
#
# def rqs(string)
#     snip.rv = ruby_quote_string(string)

