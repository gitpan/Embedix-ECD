" Vim syntax file
" Language:	ecd (Embedix Component Description) files
" Maintainer:	John Beppu <beppu@lineo.com>
" URL:		none
" Last Change:	2000 Nov 25

" An ECD file contains meta-data for packages in the Embedix Linux distro.
" This syntax file is derived from apachestyle.vim 
"   by Christian Hammers <ch@westend.com>

" Remove any old syntax stuff hanging around
syn clear
syn case ignore

" specials
syn match  ecdComment	"^\s*#.*"

" options and values
syn match  ecdAttr	"^\s*[a-zA-Z]\S*\s*[=].*$" contains=ecdAttrN,ecdAttrV
syn match  ecdAttrN     contained ".*="me=e-1
syn match  ecdAttrV     contained "=.*$"ms=s+1

" tags
syn region ecdTag	start=+<+ end=+>+ contains=ecdTagN,ecdTagError
syn match  ecdTagN	contained +<[/\s]*[-a-zA-Z0-9_]\++ms=s+1
syn match  ecdTagError	contained "[^>]<"ms=s+1


if !exists("did_ecd_syntax_inits")
  let did_ecd_syntax_inits = 1

  hi link ecdComment			Comment
  hi link ecdAttr			Special
  hi link ecdAttrN			Identifier
  hi link ecdAttrV			String
  hi link ecdTag			Special
  hi link ecdTagN			Identifier
  hi link ecdTagError			Error
endif

let b:current_syntax = "ecd"
" vim: ts=8
