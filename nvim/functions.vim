
function! ClearRegisters()
    let regs=split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '\zs')
    for r in regs
        call setreg(r, [])
    endfor
endfunction

command! ClearRegisters call ClearRegisers()

function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction

command! RenameFile call RenameFile()

function! StripTrailingWhitespace()
    %s/\s\+$//e
endfunction

command! StripTrailingWhitespace call StripTrailingWhitespace()
