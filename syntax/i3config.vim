" Vim syntax file
" Language: i3 config file
" Original Author: Josef Litos (JosefLitos/i3config.vim)
" Maintainer: Quentin Hibon (github user hiqua)
" Version: 1.2.0
" Last Change: 2024-04-13

" References:
" http://i3wm.org/docs/userguide.html#configuring
" http://vimdoc.sourceforge.net/htmldoc/syntax.html
"
"
" Quit when a syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

scriptencoding utf-8

" Error
syn match i3ConfigError /.\+/

" Todo
syn keyword i3ConfigTodo TODO FIXME XXX contained

" Helper type definitions
syn match i3ConfigSeparator /[,;\\]/ contained
syn match i3ConfigParen /[{}]/ contained
syn keyword i3ConfigBoolean yes no enabled disabled on off true false contained
" String in simpler (matchable end) and more robust (includes `extend` keyword) forms
syn match i3ConfigString /\(["']\)[^\\"')\]}]*\1/ contained contains=i3ConfigShCommand,i3ConfigShDelim,i3ConfigShOper,i3ConfigShParam,@i3ConfigNumVar,i3ConfigExecAction
syn region i3ConfigString start=/"[^\\"')\]}]*[\\')\]}]/ skip=/\\\@<=\("\|$\)/ end=/"\|$/ contained contains=i3ConfigShCommand,i3ConfigShDelim,i3ConfigShOper,i3ConfigShParam,@i3ConfigNumVar,i3ConfigExecAction keepend extend
syn region i3ConfigString start=/'[^\\"')\]}]*[\\")\]}]/ skip=/\\\@<=$/ end=/'\|$/ contained contains=i3ConfigShCommand,i3ConfigShDelim,i3ConfigShOper,i3ConfigShParam,@i3ConfigNumVar,i3ConfigExecAction keepend extend
syn match i3ConfigColor /#[0-9A-Fa-f]\{3,8}/ contained
syn match i3ConfigNumber /[0-9A-Za-z_$-]\@<!-\?\d\+\w\@!/ contained
" Grouping of common usages
syn cluster i3ConfigStrVar contains=i3ConfigString,i3ConfigVariable
syn cluster i3ConfigNumVar contains=i3ConfigNumber,i3ConfigVariable
syn cluster i3ConfigIdent contains=i3ConfigString,i3ConfigNumber,i3ConfigVariable
syn cluster i3ConfigValue contains=@i3ConfigIdent,i3ConfigBoolean

" 4.1 Include directive
syn match i3ConfigIncludeCommand /`[^`]*`/ contained contains=@i3ConfigSh
syn region i3ConfigParamLine matchgroup=i3ConfigKeyword start=/^include / end=/$/ contains=@i3ConfigStrVar,i3ConfigIncludeCommand,i3ConfigShOper keepend

" 4.2 Comments
syn match i3ConfigComment /^\s*#.*$/ contains=i3ConfigTodo

" 4.3 Fonts
syn match i3ConfigColonOperator /:/ contained
syn match i3ConfigFontNamespace /\w\+:/ contained contains=i3ConfigColonOperator
syn match i3ConfigFontSize / \d\+\(px\)\?\s\?$/ contained
syn region i3ConfigParamLine matchgroup=i3ConfigKeyword start=/^\s*font / skip=/\\$/ end=/$/ contains=i3ConfigFontNamespace,i3ConfigFontSize,i3ConfigSeparator keepend containedin=i3ConfigBarBlock

" 4.4-4.5 Keyboard/Mouse bindings
syn match i3ConfigBindArgument /--\(release\|border\|whole-window\|exclude-titlebar\) / contained nextgroup=i3ConfigBindArgument,i3ConfigBindCombo
syn match i3ConfigBindModifier /+/ contained
syn keyword i3ConfigBindModkey Ctrl Shift Mod1 Mod2 Mod3 Mod4 Mod5 contained
syn match i3ConfigBindCombo /[$0-9A-Za-z_+]\+ / contained contains=i3ConfigBindModifier,i3ConfigVariable,i3ConfigBindModkey nextgroup=i3ConfigBind
syn cluster i3ConfigBinder contains=i3ConfigCriteria,@i3ConfigCommand,i3ConfigSeparator
syn region i3ConfigBind start=/\zs/ skip=/\\$/ end=/$/ contained contains=@i3ConfigBinder keepend
syn match i3ConfigBindKeyword /^\s*bind\(sym\|code\) / nextgroup=i3ConfigBindArgument,i3ConfigBindCombo

" 4.6 Binding modes
syn region i3ConfigModeBlock matchgroup=i3ConfigKeyword start=/^mode\ze\( --pango_markup\)\? \([^'" {]\+\|'[^']\+'\|".\+"\)\s\+{$/ end=/^}\zs$/ contains=i3ConfigShParam,@i3ConfigStrVar,i3ConfigBindKeyword,i3ConfigComment,i3ConfigParen fold keepend extend

" 4.7 Floating modifier
syn match i3ConfigKeyword /^floating_modifier / nextgroup=i3ConfigVariable,i3ConfigBindModkey

" 4.8 Floating window size
syn keyword i3ConfigSizeSpecial x contained
syn match i3ConfigSize / -\?\d\+ x -\?\d\+/ contained contains=i3ConfigSizeSpecial,i3ConfigNumber
syn match i3ConfigKeyword /^floating_\(maximum\|minimum\)_size / nextgroup=i3ConfigSize

" 4.9 Orientation
syn keyword i3ConfigOrientationOpts vertical horizontal auto contained
syn match i3ConfigKeyword /^default_orientation / nextgroup=i3ConfigOrientationOpts

" 4.10 Layout mode
syn keyword i3ConfigWorkspaceLayoutOpts default stacking tabbed contained
syn match i3ConfigKeyword /^workspace_layout / nextgroup=i3ConfigWorkspaceLayoutOpts

" 4.11 Title alignment
syn keyword i3ConfigTitleAlignOpts left center right contained
syn match i3ConfigKeyword /^title_align / nextgroup=i3ConfigTitleAlignOpts

" 4.12 Border style
syn keyword i3ConfigBorderOpts none normal pixel contained
syn match i3ConfigKeyword /^default\(_floating\)\?_border .*$/ contains=i3ConfigBorderOpts,@i3ConfigNumVar

" 4.13 Hide edge borders
syn keyword i3ConfigEdgeOpts none vertical horizontal both smart smart_no_gaps contained
syn match i3ConfigKeyword /^hide_edge_borders / nextgroup=i3ConfigEdgeOpts

" 4.14 Smart Borders
syn keyword i3ConfigSmartBorderOpts no_gaps contained
syn match i3ConfigKeyword /^smart_borders / nextgroup=i3ConfigSmartBorderOpts,i3ConfigBoolean

" 4.15 Arbitrary commands
syn match i3ConfigKeyword /^for_window / nextgroup=i3ConfigCriteria

" 4.16 No opening focus
syn match i3ConfigKeyword /^no_focus / nextgroup=i3ConfigCondition

" 4.17 Variables
syn match i3ConfigVariable /\$[0-9A-Za-z_:|[\]-]\+/
syn region i3ConfigSet matchgroup=i3ConfigKeyword start=/^set\ze\s\+\$/ skip=/\\$/ end=/$/ contains=@i3ConfigSh,@i3ConfigValue,i3ConfigColor,i3ConfigBindModkey keepend

" 4.18 X resources
syn keyword i3ConfigResourceKeyword set_from_resource contained
syn match i3ConfigParamLine /^set_from_resource\s\+.*$/ contains=i3ConfigResourceKeyword,i3ConfigCondition,i3ConfigColor,@i3ConfigIdent

" 4.19 Assign clients to workspaces
syn match i3ConfigAssignSpecial /→\|number/ contained
syn region i3ConfigAssign matchgroup=i3ConfigKeyword start=/^assign / end=/$/ contains=i3ConfigAssignSpecial,i3ConfigCondition,@i3ConfigIdent keepend

" 4.20 Executing shell commands
syn region i3ConfigShCommand matchgroup=i3ConfigShDelim start=/\$(/ end=/)/ contained contains=i3ConfigExecAction,i3ConfigShCommand,i3ConfigShDelim,i3ConfigShOper,i3ConfigShParam,i3ConfigString,i3ConfigNumber,i3ConfigVariable extend
syn match  i3ConfigShDelim /[[\]{}();`]\+/ contained
syn match  i3ConfigShOper /[<>&|+=~^*!.?]\+/ contained
syn match i3ConfigShParam /\<-[A-Za-z-][0-9A-Za-z_-]*\>/ contained
syn cluster i3ConfigSh contains=@i3ConfigIdent,i3ConfigShOper,i3ConfigShDelim,i3ConfigShParam,i3ConfigShCommand
syn region i3ConfigExecAlways matchgroup=i3ConfigKeyword start=/^exec_always\ze \(--no-startup-id \)\?[^{]/ skip=/\\$/ end=/$/ contains=i3ConfigExecAction,@i3ConfigSh keepend
syn region i3ConfigExec matchgroup=i3ConfigCommand start=/^\s*exec\ze \(--no-startup-id \)\?[^{]/ skip=/\\$/ end=/$/ contains=i3ConfigExecAction,@i3ConfigSh keepend

" 4.21 Workspaces per output
syn keyword i3ConfigWorkspaceOutput output contained
syn keyword i3ConfigWorkspaceDir prev next back_and_forth number contained
syn region i3ConfigWorkspaceLine matchgroup=i3ConfigCommand start=/^workspace / skip=/\\$/ end=/$/ contains=i3ConfigGaps,i3ConfigWorkspaceOutput,@i3ConfigIdent,i3ConfigBoolean,i3ConfigSeparator keepend

" 4.22 Changing colors
syn match i3ConfigDotOperator /\./ contained
syn keyword i3ConfigClientOpts focused focused_inactive unfocused urgent placeholder background contained
syn match i3ConfigKeyword /^client\..*$/ contains=i3ConfigDotOperator,i3ConfigClientOpts,i3ConfigColor,i3ConfigVariable

" 4.23 Interprocess communication
syn region i3ConfigParamLine matchgroup=i3ConfigKeyword start=/^ipc-socket / end=/$/ contains=i3ConfigNumber

" 4.24 Focus follows mouse
syn keyword i3ConfigFocusFollowsMouseOpts always contained
syn match i3ConfigKeyword /^focus_follows_mouse / nextgroup=i3ConfigBoolean,i3ConfigFocusFollowsMouseOpts

" 4.25 Mouse warping
syn keyword i3ConfigMouseWarpingOpts output container none contained
syn match i3ConfigKeyword /^mouse_warping / nextgroup=i3ConfigMouseWarpingOpts

" 4.26 Popups while fullscreen
syn keyword i3ConfigPopupFullscreenOpts smart ignore leave_fullscreen contained
syn match i3ConfigKeyword /^popup_during_fullscreen / nextgroup=i3ConfigPopupFullscreenOpts

" 4.27 Focus wrapping
syn keyword i3ConfigFocusWrappingOpts force workspace contained
syn match i3ConfigKeyword /^focus_wrapping / nextgroup=i3ConfigBoolean,i3ConfigFocusWrappingOpts

" 4.28 Forcing Xinerama
syn match i3ConfigKeyword /^force_xinerama / nextgroup=i3ConfigBoolean

" 4.29 Automatic workspace back-and-forth
syn match i3ConfigKeyword /^workspace_auto_back_and_forth / nextgroup=i3ConfigBoolean

" 4.30 Delay urgency hint
syn keyword i3ConfigTimeUnit ms contained
syn match i3ConfigKeyword /^force_display_urgency_hint \d\+\( ms\)\?$/ contains=i3ConfigNumber,i3ConfigTimeUnit

" 4.31 Focus on window activation
syn keyword i3ConfigFocusOnActivationOpts smart urgent focus none contained
syn match i3ConfigKeyword /^focus_on_window_activation / nextgroup=i3ConfigFocusOnActivationOpts

" 4.32 Show marks in title
syn match i3ConfigCommand /^show_marks / nextgroup=i3ConfigBoolean

" 4.34 Tiling drag
syn keyword i3ConfigTilingDragOpts modifier titlebar contained
syn match i3ConfigKeyword /^tiling_drag\( off\|\( modifier\| titlebar\)\{1,2\}\)$/ contains=i3ConfigTilingDragOpts,i3ConfigBoolean

" 4.35 Gaps
syn keyword i3ConfigGapsOpts inner outer horizontal vertical left right top bottom current all set plus minus toggle contained
syn region i3ConfigGaps matchgroup=i3ConfigCommand start=/gaps/ skip=/\\$/ end=/[,;]\zs\|$/ contained contains=i3ConfigGapsOpts,@i3ConfigNumVar,i3ConfigSeparator keepend
syn match i3ConfigGapsLine /^gaps .*$/ contains=i3ConfigGaps
syn keyword i3ConfigSmartGapOpts inverse_outer contained
syn match i3ConfigKeyword /^smart_gaps \(on\|off\|inverse_outer\)$/ contains=i3ConfigSmartGapOpts,i3ConfigBoolean

" 5 Configuring bar
syn match i3ConfigBarModifier /^\s\+modifier \S\+$/ contained contains=i3ConfigBindModifier,i3ConfigVariable,i3ConfigBindModkey,i3ConfigBarOptVals
syn keyword i3ConfigBarOpts bar i3bar_command status_command mode hidden_state id position output tray_output tray_padding separator_symbol workspace_buttons workspace_min_width strip_workspace_numbers strip_workspace_name binding_mode_indicator padding contained
syn keyword i3ConfigBarOptVals dock hide invisible show none top bottom primary nonprimary contained
syn region i3ConfigBarBlock start=/^bar {$/ end=/^}$/ contains=i3ConfigBarOpts,i3ConfigBarOptVals,i3ConfigBarModifier,i3ConfigBindKeyword,@i3ConfigSh,@i3ConfigValue,i3ConfigComment,i3ConfigColorsBlock fold keepend extend

" 5.16 Color block
syn match i3ConfigColorsOpts /\(focused_\)\?\(background\|statusline\|separator\)\|\(focused\|active\|inactive\|urgent\)_workspace\|binding_mode/ contained
syn region i3ConfigColorsBlock matchgroup=i3ConfigKeyword start=/^\s\+colors \ze{$/ end=/^\s\+}\zs$/ contained contains=i3ConfigColorsOpts,i3ConfigColor,i3ConfigVariable,i3ConfigComment,i3ConfigParen fold keepend extend

" 6.0 Command criteria
syn keyword i3ConfigConditionProp class instance window_role window_type machine id title urgent workspace con_mark con_id floating_from tiling_from contained
syn keyword i3ConfigConditionSpecial __focused__ all floating tiling contained
syn region i3ConfigCondition matchgroup=i3ConfigShDelim start=/\[/ end=/\]/ contained contains=i3ConfigConditionProp,i3ConfigShOper,i3ConfigConditionSpecial,@i3ConfigIdent keepend extend
syn region i3ConfigCriteria start=/\[/ skip=/\\$/ end=/\(;\|$\)/ contained contains=i3ConfigCondition,@i3ConfigCommand,i3ConfigSeparator keepend transparent

" 6.1 Actions through shell
syn match i3ConfigExecActionKeyword /i3-msg/ contained
syn cluster i3ConfigExecActionVal contains=i3ConfigExecActionKeyword,i3ConfigCriteria,i3ConfigAction,i3ConfigActionKeyword,i3ConfigOption,@i3ConfigNumVar
syn region i3ConfigExecAction start=/[a-z3-]\+msg "/ skip=/ "\|\\$/ end=/"\|$/ contained contains=i3ConfigExecActionKeyword,@i3ConfigExecActionVal keepend extend
syn region i3ConfigExecAction start=/[a-z3-]\+msg '/ skip=/ '\|\\$/ end=/'\|$/ contained contains=i3ConfigExecActionKeyword,@i3ConfigExecActionVal keepend extend
syn region i3ConfigExecAction start=/[a-z3-]\+msg ['"-]\@!/ skip=/\\$/ end=/[&|;})'"]\@=\|$/ contained contains=i3ConfigExecActionKeyword,@i3ConfigExecActionVal keepend extend
" 6.1 Executing applications (4.20)
syn region i3ConfigAction matchgroup=i3ConfigCommand start=/exec / skip=/\\$/ end=/[,;] \zs\|$/ contained contains=i3ConfigExecAction,@i3ConfigSh,i3ConfigSeparator keepend

" 6.3 Manipulating layout
syn keyword i3ConfigLayoutOpts default tabbed stacking splitv splith toggle split all contained
syn region i3ConfigAction matchgroup=i3ConfigCommand start=/layout / skip=/\\$/ end=/[,;]\|$/ contained contains=i3ConfigLayoutOpts,i3ConfigSeparator keepend transparent

" 6.4 Focusing containers
syn keyword i3ConfigFocusOpts left right up down parent child next prev sibling floating tiling mode_toggle contained
syn keyword i3ConfigFocusOutputOpts left right down up current primary nonprimary next prev contained
syn region i3ConfigFocusOutput start=/ output / skip=/\\$/ end=/[,;]\|$/ contained contains=i3ConfigWorkspaceOutput,i3ConfigFocusOutputOpts,@i3ConfigIdent,i3ConfigSeparator keepend
syn match i3ConfigFocusOutputLine /^focus output .*$/ contains=i3ConfigFocusKeyword,i3ConfigFocusOutput
syn region i3ConfigAction matchgroup=i3ConfigCommand start=/focus/ skip=/\\$/ end=/[,;]\zs\|$/ contained contains=i3ConfigFocusOpts,i3ConfigFocusOutput,i3ConfigSeparator keepend transparent

" 6.8 Focusing workspaces (4.21)
syn region i3ConfigAction matchgroup=i3ConfigCommand start=/workspace/ skip=/\\$/ end=/[,;]\zs\|$/ contained contains=i3ConfigWorkspaceDir,@i3ConfigValue,i3ConfigGaps,i3ConfigWorkspaceOutput,i3ConfigSeparator keepend transparent

" 6.8.2 Renaming workspaces
syn region i3ConfigAction matchgroup=i3ConfigCommand start=/rename\ze workspace/ end=/[,;]\zs\|$/ contained contains=i3ConfigMoveDir,i3ConfigMoveType,@i3ConfigIdent keepend transparent

" 6.5,6.9-6.11 Moving containers
syn keyword i3ConfigMoveDir left right down up position absolute center to current contained
syn keyword i3ConfigMoveType window container workspace output mark mouse scratchpad contained
syn match i3ConfigUnit / px\| ppt/ contained
syn region i3ConfigAction matchgroup=i3ConfigCommand start=/move/ skip=/\\$/ end=/[,;]\zs\|$/ contained contains=i3ConfigMoveDir,i3ConfigMoveType,i3ConfigWorkspaceDir,i3ConfigUnit,@i3ConfigIdent,i3ConfigSeparator,i3ConfigShParam keepend transparent

" 6.12 Resizing containers/windows
syn keyword i3ConfigResizeOpts grow shrink up down left right set width height or contained
syn region i3ConfigAction matchgroup=i3ConfigCommand start=/resize/ skip=/\\$/ end=/[,;]\zs\|$/ contained contains=i3ConfigResizeOpts,i3ConfigNumber,i3ConfigUnit,i3ConfigSeparator keepend transparent

" 6.14 VIM-like marks
syn match i3ConfigMark /mark\( --\(add\|replace\)\( --toggle\)\?\)\?/ contained contains=i3ConfigShParam
syn region i3ConfigAction start=/\<mark/ skip=/\\$/ end=/[,;]\|$/ contained contains=i3ConfigMark,@i3ConfigIdent,i3ConfigSeparator keepend transparent

" 6.24 Changing gaps (4.35)
syn region i3ConfigAction start=/gaps/ skip=/\\$/ end=/[,;]\|$/ contained contains=i3ConfigGaps keepend transparent

" Commands useable in keybinds
syn keyword i3ConfigActionKeyword mode append_layout kill open fullscreen sticky split floating swap unmark show_marks title_window_icon title_format border restart reload exit scratchpad nop bar contained
syn keyword i3ConfigOption default enable disable toggle key restore current horizontal vertical auto none normal pixel show container with id con_id padding hidden_state hide dock invisible contained
syn cluster i3ConfigCommand contains=i3ConfigAction,i3ConfigActionKeyword,i3ConfigOption,@i3ConfigValue,i3ConfigColor

" Define the highlighting.
hi def link i3ConfigError                           Error
hi def link i3ConfigTodo                            Todo
hi def link i3ConfigKeyword                         Keyword
hi def link i3ConfigCommand                         Statement
hi def link i3ConfigParamLine                       i3ConfigString
hi def link i3ConfigOperator                        Operator
hi def link i3ConfigSeparator                       i3ConfigOperator
hi def link i3ConfigParen                           Delimiter
hi def link i3ConfigBoolean                         Boolean
hi def link i3ConfigString                          String
hi def link i3ConfigColor                           Constant
hi def link i3ConfigNumber                          Number
hi def link i3ConfigComment                         Comment
hi def link i3ConfigColonOperator                   i3ConfigOperator
hi def link i3ConfigFontNamespace                   i3ConfigOption
hi def link i3ConfigFontSize                        i3ConfigNumber
hi def link i3ConfigBindArgument                    i3ConfigShParam
hi def link i3ConfigBindModifier                    i3ConfigOperator
hi def link i3ConfigBindModkey                      Special
hi def link i3ConfigBindCombo                       SpecialChar
hi def link i3ConfigBindKeyword                     i3ConfigKeyword
hi def link i3ConfigSizeSpecial                     i3ConfigOperator
hi def link i3ConfigOrientationOpts                 i3ConfigOption
hi def link i3ConfigWorkspaceLayoutOpts             i3ConfigOption
hi def link i3ConfigTitleAlignOpts                  i3ConfigOption
hi def link i3ConfigBorderOpts                      i3ConfigOption
hi def link i3ConfigEdgeOpts                        i3ConfigOption
hi def link i3ConfigSmartBorderOpts                 i3ConfigOption
hi def link i3ConfigVariable                        Variable
hi def link i3ConfigResourceKeyword                 i3ConfigKeyword
hi def link i3ConfigAssignSpecial                   i3ConfigOption
hi def link i3ConfigShParam                         PreProc
hi def link i3ConfigShDelim                         Delimiter
hi def link i3ConfigShOper                          Operator
hi def link i3ConfigShCommand                       Normal
hi def link i3ConfigWorkspaceOutput                 i3ConfigMoveType
hi def link i3ConfigWorkspaceDir                    i3ConfigOption
hi def link i3ConfigDotOperator                     i3ConfigOperator
hi def link i3ConfigClientOpts                      i3ConfigOption
hi def link i3ConfigFocusFollowsMouseOpts           i3ConfigOption
hi def link i3ConfigMouseWarpingOpts                i3ConfigOption
hi def link i3ConfigPopupFullscreenOpts             i3ConfigOption
hi def link i3ConfigFocusWrappingOpts               i3ConfigOption
hi def link i3ConfigTimeUnit                        i3ConfigNumber
hi def link i3ConfigFocusOnActivationOpts           i3ConfigOption
hi def link i3ConfigTilingDragOpts                  i3ConfigOption
hi def link i3ConfigGapsOpts                        i3ConfigOption
hi def link i3ConfigSmartGapOpts                    i3ConfigOption
hi def link i3ConfigBarModifier                     i3ConfigKeyword
hi def link i3ConfigBarOpts                         i3ConfigKeyword
hi def link i3ConfigBarOptVals                      i3ConfigOption
hi def link i3ConfigColorsOpts                      i3ConfigOption
hi def link i3ConfigConditionProp                   i3ConfigShParam
hi def link i3ConfigConditionSpecial                Constant
hi def link i3ConfigExecActionKeyword               i3ConfigShCommand
hi def link i3ConfigExecAction                      i3ConfigString
hi def link i3ConfigLayoutOpts                      i3ConfigOption
hi def link i3ConfigFocusOpts                       i3ConfigOption
hi def link i3ConfigFocusOutputOpts                 i3ConfigOption
hi def link i3ConfigMoveDir                         i3ConfigOption
hi def link i3ConfigMoveType                        Constant
hi def link i3ConfigUnit                            i3ConfigNumber
hi def link i3ConfigResizeOpts                      i3ConfigOption
hi def link i3ConfigMark                            i3ConfigCommand
hi def link i3ConfigActionKeyword                   i3ConfigCommand
hi def link i3ConfigOption                          Type

let b:current_syntax = "i3config"
