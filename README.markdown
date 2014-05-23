# Vim :Scheme

This allows a file or motion to be executed as a set of scheme commands.

    :% Scheme
    :1,2 Scheme
    :Scheme

or

    <leader>r<motion>

This will create a new vim buffer holding the output of the commands. This will
reuse the buffer for different invocations. The buffer will be the size of the
output or one third of the screen, whichever is smaller.
