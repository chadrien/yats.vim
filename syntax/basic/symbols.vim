" + - ^ ~
syntax match typescriptUnaryOp /[+\-\^~!]/
 \ nextgroup=@typescriptValue
 \ skipwhite

syntax region  typescriptTernaryOp start=/?/  end=/:/ contained contains=@typescriptValue,@typescriptComments nextgroup=@typescriptValue skipwhite skipempty

syntax match   typescriptAssign  contained /=/ nextgroup=@typescriptValue
  \ skipwhite skipempty

" 2: ==, ===
syntax match   typescriptBinaryOp contained /===\?/ nextgroup=@typescriptValue skipwhite skipempty
" 6: >>>=, >>>, >>=, >>, >=, >
syntax match   typescriptBinaryOp contained />\(>>=\|>>\|>=\|>\|=\)\=/ nextgroup=@typescriptValue skipwhite skipempty
" 4: <<=, <<, <=, <
syntax match   typescriptBinaryOp contained /\(<<=\|<<\|<=\|<\)/ nextgroup=@typescriptValue skipwhite skipempty
" 3: ||, |=, |
syntax match   typescriptBinaryOp contained /\(||\||=\||\)/ nextgroup=@typescriptValue skipwhite skipempty
" 3: &&, &=, &
syntax match   typescriptBinaryOp contained /\(&&\|&=\|&\)/ nextgroup=@typescriptValue skipwhite skipempty
" 2: *=, *
syntax match   typescriptBinaryOp contained /\(*=\|*\)/ nextgroup=@typescriptValue skipwhite skipempty
" 2: %=, %
syntax match   typescriptBinaryOp contained /\(%=\|%\)/ nextgroup=@typescriptValue skipwhite skipempty
syntax match   typescriptBinaryOp contained +/\(=\|[^\*/]\@=\)+ nextgroup=@typescriptValue skipwhite skipempty
" 2: /=, /
syntax match   typescriptBinaryOp contained /!==\?/ nextgroup=@typescriptValue skipwhite skipempty
" 2: !=, !==
syntax match   typescriptBinaryOp contained /+\(+\|=\)\?/ nextgroup=@typescriptValue skipwhite skipempty
" 3: +, ++, +=
syntax match   typescriptBinaryOp contained /-\(-\|=\)\?/ nextgroup=@typescriptValue skipwhite skipempty
" 3: -, --, -=

" exponentiation operator
" 2: **, **=
syntax match typescriptBinaryOp contained /\(\*\*\|\*\*=\)/ nextgroup=@typescriptValue

" syntax match   typescriptOpSymbol  contained /\(\^\|\~\)/ " 2: ^, ~

" syntax match   typescriptOpSymbols /!\+/ nextgroup=typescriptRegexpString " 1: !


" syntax match   typescriptLogicSymbols          /[^&|]\@<=\(&&\|||\)\ze\_[^&|]/ nextgroup=@typescriptValue skipwhite skipempty
" syntax cluster typescriptSymbols               contains=typescriptUnaryOp,typescriptBinaryOp,typescriptLogicSymbols
syntax cluster typescriptSymbols               contains=typescriptBinaryOp,typescriptKeywordOp,typescriptTernaryOp,typescriptAssign
