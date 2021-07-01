for f in split(glob('~/.config/nvim/plugin/*.vim'), '\n')
    exe 'source' f
endfor
for f in split(glob('~/.config/nvim/plugconf/*.vim'), '\n')
    exe 'source' f
endfor
