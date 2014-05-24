# Vim :Scheme

Evaluate lisp and scheme code easily

## TL;DR

This allows a file or motion to be executed as a set of scheme commands.

    :% Scheme
    :1,2 Scheme
    :Scheme

or

    <leader>r<motion>

This will create a new vim buffer holding the output of the commands. This will
reuse the buffer for different invocations. The buffer will be the size of the
output or one third of the screen, whichever is smaller.

This plugin is only available if 'compatible' is not set.

## Introduction

I wrote this because I was working through the SICP questions and wanted an
easy way to interpret my solutions. This command is optimised to evaluate the
current file, or a part of the current file.

The evaluation always produces output to a fixed buffer. This buffer will be
cleared and reused if it already exists. If you want to save the output then
write it to a file.

## Commands

    :[range] Scheme
Evaluate the provided range as code.

    <leader>r<motion>
Evaluate the provided motion as code.

## Configuration

The scheme evaluator can be set:

    let g:scheme_evaluator = 'mit-scheme --quiet'

Setting 'g:loaded_scheme' before the plugin loads will prevent it from loading.

Setting 'b:did_scheme_eval_ftplugin' in a buffer before setting the filetype
will prevent it from loading for that buffer.

## Final Thoughts

Fundamentally this plugin is just a way of sending text to a shell command on
standard in. You can have any command in there. Format xml with:

    let g:scheme_evaluator = 'xmllint --format -'

I should use this more...
