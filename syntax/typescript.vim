" Vim syntax file
" Language:     TypeScript
" Maintainer:   Herrington Darkholme
" Last Change:  2015-04-05
" Version:      1.0
" Changes:      Go to https:github.com/HerringtonDarkholme/yats.vim for recent changes.
" Origin:       https://github.com/othree/yajs
" Credits:      Kao Wei-Ko(othree), Jose Elera Campana, Zhao Yi, Claudio Fleiner, Scott Shattuck
"               (This file is based on their hard work), gumnos (From the #vim
"               IRC Channel in Freenode)


" if exists("b:yats_loaded")
  " finish
" else
  " let b:yats_loaded = 1
" endif
if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'typescript'
endif

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_typescript_syn_inits")
  let did_typescript_hilink = 1
  if version < 508
    let did_typescript_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
else
  finish
endif

"Dollar sign is permitted anywhere in an identifier
setlocal iskeyword-=$
if main_syntax == 'typescript'
  setlocal iskeyword+=$
  syntax cluster htmlJavaScript                 contains=TOP
endif

syntax sync fromstart

"Syntax coloring for Node.js shebang line
syntax match   shellbang "^#!.*node\>"
syntax match   shellbang "^#!.*iojs\>"


"JavaScript comments
syntax keyword typescriptCommentTodo           contained TODO FIXME XXX TBD
syntax match   typescriptLineComment           "//.*" contains=@Spell,typescriptCommentTodo,typescriptRef
syntax region  typescriptComment               start="/\*"  end="\*/" contains=@Spell,typescriptCommentTodo extend
syntax cluster typescriptComments              contains=typescriptComment,typescriptLineComment
syn match typescriptRef +///\s*<reference\s\+.*\/>$+ contains=typescriptRefD,typescriptRefS
syn region typescriptRefD start=+"+ skip=+\\\\\|\\"+ end=+"\|$+
syn region typescriptRefS start=+'+ skip=+\\\\\|\\'+ end=+'\|$+

"JSDoc
syntax case ignore

syntax region  typescriptDocComment            matchgroup=typescriptComment start="/\*\*"  end="\*/" contains=typescriptDocNotation,typescriptCommentTodo,@Spell fold keepend
syntax match   typescriptDocNotation           contained /@/ nextgroup=typescriptDocTags

syntax keyword typescriptDocTags               contained constant constructor constructs function ignore inner private public readonly static
syntax keyword typescriptDocTags               contained const dict expose inheritDoc interface nosideeffects override protected struct
syntax keyword typescriptDocTags               contained example global

" syntax keyword typescriptDocTags               contained ngdoc nextgroup=typescriptDocNGDirective
syntax keyword typescriptDocTags               contained ngdoc scope priority animations
syntax keyword typescriptDocTags               contained ngdoc restrict methodOf propertyOf eventOf eventType nextgroup=typescriptDocParam skipwhite
syntax keyword typescriptDocNGDirective        contained overview service object function method property event directive filter inputType error

syntax keyword typescriptDocTags               contained abstract virtual access augments

syntax keyword typescriptDocTags               contained arguments callback lends memberOf name type kind link mixes mixin tutorial nextgroup=typescriptDocParam skipwhite
syntax keyword typescriptDocTags               contained variation nextgroup=typescriptDocNumParam skipwhite

syntax keyword typescriptDocTags               contained author class classdesc copyright default defaultvalue nextgroup=typescriptDocDesc skipwhite
syntax keyword typescriptDocTags               contained deprecated description external host nextgroup=typescriptDocDesc skipwhite
syntax keyword typescriptDocTags               contained file fileOverview overview namespace requires since version nextgroup=typescriptDocDesc skipwhite
syntax keyword typescriptDocTags               contained summary todo license preserve nextgroup=typescriptDocDesc skipwhite

syntax keyword typescriptDocTags               contained borrows exports nextgroup=typescriptDocA skipwhite
syntax keyword typescriptDocTags               contained param arg argument property prop module nextgroup=typescriptDocNamedParamType,typescriptDocParamName skipwhite
syntax keyword typescriptDocTags               contained define enum extends implements this typedef nextgroup=typescriptDocParamType skipwhite
syntax keyword typescriptDocTags               contained return returns throws exception nextgroup=typescriptDocParamType,typescriptDocParamName skipwhite
syntax keyword typescriptDocTags               contained see nextgroup=typescriptDocRef skipwhite

syntax keyword typescriptDocTags               contained function func method nextgroup=typescriptDocName skipwhite
syntax match   typescriptDocName               contained /\h\w*/

syntax keyword typescriptDocTags               contained fires event nextgroup=typescriptDocEventRef skipwhite
syntax match   typescriptDocEventRef           contained /\h\w*#\(\h\w*\:\)\?\h\w*/

syntax match   typescriptDocNamedParamType     contained /{.\+}/ nextgroup=typescriptDocParamName skipwhite
syntax match   typescriptDocParamName          contained /\[\?\w\+\]\?/ nextgroup=typescriptDocDesc skipwhite
syntax match   typescriptDocParamType          contained /{.\+}/ nextgroup=typescriptDocDesc skipwhite
syntax match   typescriptDocA                  contained /\%(#\|\w\|\.\|:\|\/\)\+/ nextgroup=typescriptDocAs skipwhite
syntax match   typescriptDocAs                 contained /\s*as\s*/ nextgroup=typescriptDocB skipwhite
syntax match   typescriptDocB                  contained /\%(#\|\w\|\.\|:\|\/\)\+/
syntax match   typescriptDocParam              contained /\%(#\|\w\|\.\|:\|\/\|-\)\+/
syntax match   typescriptDocNumParam           contained /\d\+/
syntax match   typescriptDocRef                contained /\%(#\|\w\|\.\|:\|\/\)\+/
syntax region  typescriptDocLinkTag            contained matchgroup=typescriptDocLinkTag start=/{/ end=/}/ contains=typescriptDocTags

syntax cluster typescriptDocs                  contains=typescriptDocParamType,typescriptDocNamedParamType,typescriptDocParam

if main_syntax == "typescript"
  syntax sync clear
  syntax sync ccomment typescriptComment minlines=200
endif

syntax case match

" Types
syntax region typescriptTypeParameters matchgroup=typescriptTypeBrackets
  \ start=/</ end=/>/ skip=/\s*,\s*/
  \ contains=typescriptTypeParameter

syntax match typescriptTypeParameter /[A-Za-z]\w*/
  \ nextgroup=typescriptConstraint
  \ contained skipwhite skipnl

syntax keyword typescriptConstraint extends
  \ nextgroup=@typescriptType
  \ contained skipwhite skipnl

syntax region typescriptTypeArguments matchgroup=typescriptTypeBrackets
  \ start=/</ end=/>/ skip=/\s*,\s*/
  \ contains=@typescriptType
  \ contained

syntax cluster typescriptType contains=
  \ @typescriptCompoundType,
  \ @typescriptFunctionType,
  \ typescriptConstructorType

syntax cluster typescriptCompoundType contains=
  \ @typescriptPrimaryType,
  \ typescriptUnionOrArrayType

syntax cluster typescriptPrimaryType contains=
  \ typescriptParenthesizedType,
  \ typescriptPredefinedType,
  \ typescriptTypeReference,
  \ typescriptObjectType,
  \ typescriptTupleType,
  \ typescriptTypeQuery

syntax region typescriptParenthesizedType matchgroup=typescriptParens
  \ start=/(/ end=/)/
  \ contains=@typescriptType
  \ nextgroup=typescriptUnionOrArrayType
  \ contained

syntax keyword typescriptPredefinedType any number boolean string void
  \ nextgroup=typescriptUnionOrArrayType

syntax match typescriptTypeReference /[A-Za-z]\w*\(\.[A-Za-z]\w*\)*/
  \ nextgroup=typescriptUnionOrArrayType
  \ contains=typescriptIdentifierName

syntax region typescriptObjectType matchgroup=typescriptBraces
  \ start=/{/ end=/}/
  \ contains=@typescriptTypeMember
  \ contained

syntax cluster typescriptTypeMember contains=
  \ typescriptPropertySignature,
  \ typescriptCallSignature,
  \ typescriptConstructSignature,
  \ typescriptIndexSignature,
  \ typescriptMethodSignature

syntax region typescriptTupleType matchgroup=typescriptBraces
  \ start=/\[/ end=/\]/
  \ contains=@typescriptType
  \contained

syntax match typescriptUnionOrArrayType /\[\]\||/
  \ nextgroup=@typescriptCompoundType
  \ contains=typescriptUnion
  \ contained skipwhite

syntax match typescriptUnion /|/ containedin=typescriptUnionOrArrayType

syntax cluster typescriptFunctionType contains=typescriptGenericFunc,typescriptFuncType
syntax region typescriptGenericFunc matchgroup=typescriptTypeBrackets
  \ start=/</ end=/>/ skip=/\s*,\s*/
  \ contains=typescriptTypeParameter
  \ nextgroup=typescriptFuncType
  \ containedin=typescriptFunctionType
  \ contained skipwhite skipnl

syntax region typescriptFuncType matchgroup=typescriptParens
  \ start=/(/ end=/)/
  \ contains=@typescriptExpression
  \ nextgroup=typescriptFuncTypeArrow
  \ contained skipwhite skipnl

syntax match typescriptFuncTypeArrow /=>/
  \ nextgroup=@typescriptType
  \ containedin=typescriptFuncType
  \ contained skipwhite skipnl


syntax match typescriptConstructorType /placeholder/


syntax match   typescriptIdentifierName        /\<[^=<>!?+\-*\/%|&,;:. ~@#`"'\[\]\(\)\{\}\^0-9][^=<>!?+\-*\/%|&,;:. ~@#`"'\[\]\(\)\{\}\^]*/ nextgroup=typescriptDotNotation,typescriptParameterList,typescriptComputedProperty

"Block VariableStatement EmptyStatement ExpressionStatement IfStatement IterationStatement ContinueStatement BreakStatement ReturnStatement WithStatement LabelledStatement SwitchStatement ThrowStatement TryStatement DebuggerStatement

syntax cluster typescriptStatement             contains=typescriptBlock,typescriptVariable,@typescriptExpression,typescriptConditional,typescriptRepeat,typescriptBranch,typescriptLabel,typescriptStatementKeyword,typescriptTry,typescriptDebugger

"Syntax in the JavaScript code
" syntax match   typescriptASCII                 contained /\\\d\d\d/
syntax region  typescriptTemplateSubstitution  contained matchgroup=typescriptTemplateSB start=/\${/ end=/}/ contains=typescriptTemplateSBlock,typescriptTemplateSString
syntax region  typescriptTemplateSBlock        contained start=/{/ end=/}/ contains=typescriptTemplateSBlock,typescriptTemplateSString transparent
syntax region  typescriptTemplateSString       contained start=/\z(["']\)/  skip=/\\\\\|\\\z1\|\\\n/  end=/\z1\|$/ extend contains=typescriptTemplateSStringRB transparent
syntax match   typescriptTemplateSStringRB     /}/ contained
syntax region  typescriptString                start=/\z(["']\)/  skip=/\\\\\|\\\z1\|\\\n/  end=/\z1\|$/ nextgroup=@typescriptSymbols skipwhite skipempty
syntax region  typescriptTemplate              start=/`/  skip=/\\\\\|\\`\|\n/  end=/`\|$/ contains=typescriptTemplateSubstitution nextgroup=@typescriptSymbols skipwhite skipempty
" syntax match   typescriptTemplateTag           /\k\+/ nextgroup=typescriptTemplate
syntax region  typescriptArray                 matchgroup=typescriptBraces start=/\[/ end=/]/ contains=@typescriptValue,typescriptForComprehension nextgroup=@typescriptSymbols,@typescriptComments skipwhite skipempty

syntax match   typescriptNumber                /\<0[bB][01]\+\>/ nextgroup=@typescriptSymbols skipwhite skipempty
syntax match   typescriptNumber                /\<0[oO][0-7]\+\>/ nextgroup=@typescriptSymbols skipwhite skipempty
syntax match   typescriptNumber                /\<0[xX][0-9a-fA-F]\+\>/ nextgroup=@typescriptSymbols skipwhite skipempty
syntax match   typescriptNumber                /[+-]\=\%(\d\+\.\d\+\|\d\+\|\.\d\+\)\%([eE][+-]\=\d\+\)\=\>/ nextgroup=@typescriptSymbols skipwhite skipempty

syntax cluster typescriptTypes                 contains=typescriptString,typescriptTemplate,typescriptNumber,typescriptBoolean,typescriptNull,typescriptArray
syntax cluster typescriptValue                 contains=@typescriptTypes,@typescriptExpression,typescriptFuncKeyword,typescriptObjectLiteral,typescriptIdentifier,typescriptIdentifierName,typescriptOperator,@typescriptSymbols

syntax match   typescriptLabel                 /[a-zA-Z_$]\k*\_s*:/he=e-1 contains=typescriptReserved nextgroup=@typescriptValue,@typescriptStatement skipwhite skipempty
syntax match   typescriptObjectLabel           contained /\k\+\_s*:/he=e-1 nextgroup=@typescriptValue,@typescriptStatement skipwhite skipempty
" syntax match   typescriptPropertyName          contained /"[^"]\+"\s*:/he=e-1 nextgroup=@typescriptValue skipwhite skipempty
" syntax match   typescriptPropertyName          contained /'[^']\+'\s*:/he=e-1 nextgroup=@typescriptValue skipwhite skipempty
syntax region  typescriptPropertyName          contained start=/\z(["']\)/  skip=/\\\\\|\\\z1\|\\\n/  end=/\z1\_s*:\|$/he=e-1 nextgroup=@typescriptValue skipwhite skipempty
syntax region  typescriptComputedPropertyName  contained matchgroup=typescriptPropertyName start=/\[/rs=s+1 end=/]\_s*:/he=e-1 contains=@typescriptValue nextgroup=@typescriptValue skipwhite skipempty
syntax region  typescriptComputedProperty      contained matchgroup=typescriptProperty start=/\[/rs=s+1 end=/]/he=e-1 contains=@typescriptValue,@typescriptSymbols nextgroup=@typescriptValue skipwhite skipempty
" Value for object, statement for label statement

syntax cluster typescriptTemplates             contains=typescriptTemplate,typescriptTemplateSubstitution,typescriptTemplateSBlock,typescriptTemplateSString,typescriptTemplateSStringRB,typescriptTemplateSB
syntax cluster typescriptStrings               contains=typescriptProp,typescriptString,@typescriptTemplates,@typescriptComments,typescriptDocComment,typescriptRegexpString,typescriptPropertyName
syntax cluster typescriptNoReserved            contains=@typescriptStrings,@typescriptDocs,shellbang,typescriptObjectLiteral,typescriptObjectLabel
"https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Lexical_grammar#Keywords
syntax keyword typescriptReserved              containedin=ALLBUT,@typescriptNoReserved break case catch class const continue
syntax keyword typescriptReserved              containedin=ALLBUT,@typescriptNoReserved debugger default delete do else export
syntax keyword typescriptReserved              containedin=ALLBUT,@typescriptNoReserved extends finally for function if
"import,typescriptRegexpString,typescriptPropertyName
syntax keyword typescriptReserved              containedin=ALLBUT,@typescriptNoReserved in instanceof let new return super
syntax keyword typescriptReserved              containedin=ALLBUT,@typescriptNoReserved switch throw try typeof var
syntax keyword typescriptReserved              containedin=ALLBUT,@typescriptNoReserved void while with yield

syntax keyword typescriptReserved              containedin=ALLBUT,@typescriptNoReserved enum implements package protected static
syntax keyword typescriptReserved              containedin=ALLBUT,@typescriptNoReserved interface private public abstract boolean
syntax keyword typescriptReserved              containedin=ALLBUT,@typescriptNoReserved byte char double final float goto int
syntax keyword typescriptReserved              containedin=ALLBUT,@typescriptNoReserved long native short synchronized transient
syntax keyword typescriptReserved              containedin=ALLBUT,@typescriptNoReserved volatile

"this

"JavaScript Prototype
syntax keyword typescriptPrototype             prototype

"Program Keywords
syntax keyword typescriptIdentifier            arguments this
syntax keyword typescriptVariable              let var const
syntax keyword typescriptOperator              delete new instanceof typeof void in nextgroup=@typescriptValue,@typescriptTypes skipwhite skipempty
syntax keyword typescriptForOperator           contained in of
syntax keyword typescriptBoolean               true false nextgroup=@typescriptSymbols skipwhite skipempty
syntax keyword typescriptNull                  null undefined nextgroup=@typescriptSymbols skipwhite skipempty
syntax keyword typescriptMessage               alert confirm prompt status
syntax keyword typescriptGlobal                self top parent

"Statement Keywords
syntax keyword typescriptConditional           if else switch
syntax keyword typescriptConditionalElse       else
syntax keyword typescriptRepeat                do while for nextgroup=typescriptLoopParen skipwhite skipempty
syntax keyword typescriptBranch                break continue
syntax keyword typescriptCase                  case nextgroup=@typescriptTypes skipwhite
syntax keyword typescriptDefault               default
syntax keyword typescriptStatementKeyword      return with yield

syntax keyword typescriptTry                   try
syntax keyword typescriptExceptions            catch throw finally
syntax keyword typescriptDebugger              debugger

syntax match   typescriptProp                  contained /[a-zA-Z_$][a-zA-Z0-9_$]*/ contains=@props transparent nextgroup=@typescriptSymbols skipwhite skipempty
syntax match   typescriptMethod                contained /[a-zA-Z_$][a-zA-Z0-9_$]*\ze(/ contains=@props transparent nextgroup=typescriptParameterList
syntax match   typescriptDotNotation           /\./ nextgroup=typescriptProp,typescriptMethod
syntax match   typescriptDotStyleNotation      /\.style\./ nextgroup=typescriptDOMStyle transparent

runtime syntax/yats/typescript.vim
runtime syntax/yats/es6-number.vim
runtime syntax/yats/es6-string.vim
runtime syntax/yats/es6-array.vim
runtime syntax/yats/es6-object.vim
runtime syntax/yats/es6-symbol.vim
runtime syntax/yats/es6-function.vim
runtime syntax/yats/es6-math.vim
runtime syntax/yats/es6-date.vim
runtime syntax/yats/es6-json.vim
runtime syntax/yats/es6-regexp.vim
runtime syntax/yats/es6-map.vim
runtime syntax/yats/es6-set.vim
runtime syntax/yats/es6-proxy.vim
runtime syntax/yats/es6-promise.vim
runtime syntax/yats/ecma-402.vim
runtime syntax/yats/node.vim
runtime syntax/yats/web.vim
runtime syntax/yats/web-window.vim
runtime syntax/yats/web-navigator.vim
runtime syntax/yats/web-location.vim
runtime syntax/yats/web-history.vim
runtime syntax/yats/web-console.vim
runtime syntax/yats/web-xhr.vim
runtime syntax/yats/web-blob.vim
runtime syntax/yats/web-crypto.vim
runtime syntax/yats/web-fetch.vim
runtime syntax/yats/web-service-worker.vim
runtime syntax/yats/dom-node.vim
runtime syntax/yats/dom-elem.vim
runtime syntax/yats/dom-document.vim
runtime syntax/yats/dom-event.vim
runtime syntax/yats/dom-storage.vim
runtime syntax/yats/css.vim

let typescript_props = 1

runtime syntax/yats/event.vim
syntax region  typescriptEventString           contained start=/\z(["']\)/  skip=/\\\\\|\\\z1\|\\\n/  end=/\z1\|$/ contains=typescriptASCII,@events

"Import
syntax region  typescriptImportDef             start=/import/ end=/;\|$/ contains=typescriptImport,typescriptString
syntax keyword typescriptImport                contained from as import
syntax keyword typescriptExport                export module

syntax region  typescriptBlock                 matchgroup=typescriptBraces start=/\([\^:]\s\*\)\=\zs{/ end=/}/ contains=@htmlJavaScript

syntax region  typescriptMethodDef             contained start=/\(\(\(set\|get\)\_s\+\)\?\)[a-zA-Z_$]\k*\_s*(/ end=/)/ contains=typescriptMethodAccessor,typescriptMethodName,typescriptFuncArg nextgroup=typescriptBlock skipwhite keepend
syntax keyword typescriptMethodAccessor        contained get set
syntax match   typescriptMethodName            contained /[a-zA-Z_$]\k*\ze\_s*(/

syntax keyword typescriptAsyncFuncKeyword      async await
" syntax keyword typescriptFuncKeyword           function nextgroup=typescriptFuncName,typescriptFuncArg skipwhite
syntax keyword typescriptFuncKeyword           function nextgroup=typescriptAsyncFunc,typescriptSyncFunc
syntax match   typescriptSyncFunc              contained // nextgroup=typescriptFuncName,typescriptFuncArg skipwhite skipempty
syntax match   typescriptAsyncFunc             contained /*/ nextgroup=typescriptFuncName,typescriptFuncArg skipwhite skipempty
syntax match   typescriptFuncName              contained /[a-zA-Z_$]\k*/ nextgroup=typescriptFuncArg skipwhite
syntax match   typescriptFuncArg               contained /([^()]*)/ contains=typescriptParens,typescriptFuncKeyword,typescriptFuncComma nextgroup=typescriptBlock skipwhite skipwhite skipempty
syntax match   typescriptFuncComma             contained /,/


"Class
syntax keyword typescriptClassKeyword          class nextgroup=typescriptClassName skipwhite
syntax keyword typescriptClassSuper            super
syntax match   typescriptClassName             contained /\k\+/ nextgroup=typescriptClassBlock,typescriptClassExtends skipwhite
syntax keyword typescriptClassExtends          contained extends nextgroup=typescriptClassName skipwhite
syntax region  typescriptClassBLock            contained matchgroup=typescriptBraces start=/{/ end=/}/ contains=typescriptMethodDef,typescriptClassStatic
syntax keyword typescriptClassStatic           contained static nextgroup=typescriptMethodDef skipwhite


"For Comprehension
syntax keyword typescriptForComprehension      contained for nextgroup=typescriptForComprehensionTail skipwhite skipempty
syntax region  typescriptForComprehensionTail  contained matchgroup=typescriptParens start=/(/ end=/)/ contains=typescriptOfComprehension,@typescriptExpression nextgroup=typescriptForComprehension,typescriptIfComprehension,@typescriptExpression skipwhite skipempty
syntax keyword typescriptOfComprehension       contained of
syntax keyword typescriptIfComprehension       contained if nextgroup=typescriptIfComprehensionTail
syntax region  typescriptIfComprehensionTail   contained matchgroup=typescriptParens start=/(/ end=/)/ contains=typescriptExpression nextgroup=typescriptForComprehension,typescriptIfComprehension skipwhite skipempty

syntax region  typescriptObjectLiteral         contained matchgroup=typescriptBraces start=/{/ end=/}/ contains=@typescriptComments,typescriptObjectLabel,typescriptPropertyName,typescriptMethodDef,typescriptComputedPropertyName,@typescriptValue

" syntax match   typescriptBraces                /[\[\]]/
" syntax match   typescriptParens                /[()]/
" syntax match   typescriptOpSymbols             /[^+\-*/%\^=!<>&|?]\@<=\(<\|>\|<=\|>=\|==\|!=\|===\|!==\|+\|-\|*\|%\|++\|--\|<<\|>>\|>>>\|&\||\|^\|!\|\~\|&&\|||\|?\|=\|+=\|-=\|*=\|%=\|<<=\|>>=\|>>>=\|&=\||=\|^=\|\/\|\/=\)\ze\_[^+\-*/%\^=!<>&|?]/ nextgroup=@typescriptExpression skipwhite
syntax match   typescriptOpSymbols             /[^+\-*/%\^=!<>&|?:]\@<=\(<\|>\|<=\|>=\|==\|!=\|===\|!==\|+\|*\|%\|++\|--\|<<\|>>\|>>>\|&\||\|^\|!\|\~\|&&\|||\|?\|=\|+=\|-=\|*=\|%=\|<<=\|>>=\|>>>=\|&=\||=\|^=\|\/\|\/=\)\ze\_[^+\-*/%\^=!<>&|?:]/ nextgroup=@typescriptExpression skipwhite skipempty
syntax match   typescriptOpSymbols             /[^+\-*/%\^=!<>&|?:]\@<=\(:\)\ze\_[^+\-*/%\^=!<>&|?:]/ nextgroup=@typescriptStatement,typescriptCase skipwhite skipempty
syntax match   typescriptEndColons             /[;,]/
syntax match   typescriptLogicSymbols          /[^&|]\@<=\(&&\|||\)\ze\_[^&|]/ nextgroup=@typescriptExpression skipwhite skipempty
syntax cluster typescriptSymbols               contains=typescriptOpSymbols,typescriptLogicSymbols

syntax region  typescriptRegexpString          start="\(^\|=\|(\|{\|;\)\@<=\_s*/[^/*]"me=e-1 skip="\\\\\|\\/" end="/[gimy]\{0,2\}" oneline

syntax cluster typescriptEventTypes            contains=typescriptEventString,typescriptTemplate,typescriptNumber,typescriptBoolean,typescriptNull
syntax cluster typescriptOps                   contains=typescriptOpSymbols,typescriptLogicSymbols,typescriptOperator
syntax region  typescriptParenExp              matchgroup=typescriptParens start=/(/ end=/)/ contains=@typescriptExpression nextgroup=@typescriptSymbols skipwhite skipempty
syntax cluster typescriptExpression            contains=typescriptArrowFuncDef,typescriptParenExp,@typescriptValue,typescriptObjectLiteral,typescriptFuncKeyword,typescriptIdentifierName,typescriptRegexpString,@typescriptTypes,@typescriptOps,typescriptGlobal,jsxRegion
syntax cluster typescriptEventExpression       contains=typescriptArrowFuncDef,typescriptParenExp,@typescriptValue,typescriptObjectLiteral,typescriptFuncKeyword,typescriptIdentifierName,typescriptRegexpString,@typescriptEventTypes,@typescriptOps,typescriptGlobal,jsxRegion

syntax region  typescriptLoopParen             contained matchgroup=typescriptParens start=/(/ end=/)/ contains=typescriptVariable,typescriptForOperator,typescriptEndColons,@typescriptExpression nextgroup=typescriptBlock skipwhite skipempty

" syntax match   typescriptFuncCall              contained /[a-zA-Z]\k*\ze(/ nextgroup=typescriptParameterList
syntax region  typescriptParameterList           contained matchgroup=typescriptParens start=/(/ end=/)/ contains=@typescriptExpression nextgroup=typescriptOpSymbols,typescriptDotNotation skipwhite skipempty
syntax cluster typescriptSymbols               contains=typescriptOpSymbols,typescriptLogicSymbols
syntax region  typescriptEventFuncCallArg      contained matchgroup=typescriptParens start=/(/ end=/)/ contains=@typescriptEventExpression

syntax match   typescriptArrowFuncDef          contained /([^)]*)\_s*=>/ contains=typescriptFuncArg,typescriptArrowFunc nextgroup=typescriptBlock skipwhite skipempty
syntax match   typescriptArrowFuncDef          contained /[a-zA-Z_]\k*\_s*=>/ contains=typescriptArrowFuncArg,typescriptArrowFunc nextgroup=typescriptBlock skipwhite skipempty
syntax match   typescriptArrowFunc             /=>/
syntax match   typescriptArrowFuncArg          contained /[a-zA-Z_]\k*/

if exists("did_typescript_hilink")
  HiLink typescriptReserved             Error

  HiLink typescriptEndColons            Exception
  HiLink typescriptOpSymbols            Normal
  HiLink typescriptLogicSymbols         Boolean
  HiLink typescriptBraces               Function
  HiLink typescriptParens               Normal
  HiLink typescriptComment              Comment
  HiLink typescriptLineComment          Comment
  HiLink typescriptDocComment           Comment
  HiLink typescriptCommentTodo          Todo
  HiLink typescriptRef                  Include
  HiLink typescriptRefS                 String
  HiLink typescriptRefD                 String
  HiLink typescriptDocNotation          SpecialComment
  HiLink typescriptDocTags              SpecialComment
  HiLink typescriptDocNGParam           typescriptDocParam
  HiLink typescriptDocParam             Function
  HiLink typescriptDocNumParam          Function
  HiLink typescriptDocEventRef          Function
  HiLink typescriptDocNamedParamType    Type
  HiLink typescriptDocParamName         Type
  HiLink typescriptDocParamType         Type
  HiLink typescriptString               String
  HiLink typescriptTemplate             String
  HiLink typescriptEventString          String
  HiLink typescriptASCII                Label
  HiLink typescriptTemplateSubstitution Label
  " HiLink typescriptTemplateSBlock       Label
  " HiLink typescriptTemplateSString      Label
  HiLink typescriptTemplateSStringRB    typescriptTemplateSubstitution
  HiLink typescriptTemplateSB           typescriptTemplateSubstitution
  HiLink typescriptRegexpString         String
  HiLink typescriptGlobal               Constant
  HiLink typescriptCharacter            Character
  HiLink typescriptPrototype            Type
  HiLink typescriptConditional          Conditional
  HiLink typescriptConditionalElse      Conditional
  HiLink typescriptCase                 Conditional
  HiLink typescriptDefault              typescriptCase
  HiLink typescriptBranch               Conditional
  HiLink typescriptIdentifier           Structure
  HiLink typescriptVariable             Identifier
  HiLink typescriptRepeat               Repeat
  HiLink typescriptForComprehension     Repeat
  HiLink typescriptIfComprehension      Repeat
  HiLink typescriptOfComprehension      Repeat
  HiLink typescriptForOperator          Repeat
  HiLink typescriptStatementKeyword     Statement
  HiLink typescriptMessage              Keyword
  HiLink typescriptOperator             Identifier
  HiLink typescriptType                 Type
  HiLink typescriptNull                 Boolean
  HiLink typescriptNumber               Number
  HiLink typescriptBoolean              Boolean
  HiLink typescriptObjectLabel          typescriptLabel
  HiLink typescriptLabel                Label
  HiLink typescriptPropertyName         Label
  HiLink typescriptImport               Special
  HiLink typescriptExport               Special
  HiLink typescriptTry                  Special
  HiLink typescriptExceptions           Special

  HiLink typescriptMethodName           Function
  HiLink typescriptMethodAccessor       Operator

  HiLink typescriptAsyncFuncKeyword     Keyword
  HiLink typescriptFuncKeyword          Keyword
  HiLink typescriptAsyncFunc            Keyword
  HiLink typescriptArrowFunc            Type
  HiLink typescriptFuncName             Function
  HiLink typescriptFuncArg              Special
  HiLink typescriptArrowFuncArg         typescriptFuncArg
  HiLink typescriptFuncComma            Operator

  HiLink typescriptClassKeyword         Keyword
  HiLink typescriptClassExtends         Keyword
  HiLink typescriptClassName            Function
  HiLink typescriptClassStatic          StorageClass
  HiLink typescriptClassSuper           keyword

  HiLink shellbang                      Comment

  HiLink typescriptTypeParameter        Identifier
  HiLink typescriptConstraint           Keyword
  HiLink typescriptPredefinedType       Type
  HiLink typescriptUnion                Operator
  HiLink typescriptFuncTypeArrow        Function

  highlight link javaScript             NONE

  delcommand HiLink
  unlet did_typescript_hilink
endif

let b:current_syntax = "typescript"
if main_syntax == 'typescript'
  unlet main_syntax
endif
