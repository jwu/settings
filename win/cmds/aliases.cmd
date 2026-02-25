;= @echo off
;= rem ls=ls --show-control-chars -F --color $*
;= rem Call DOSKEY and use this file as the macrofile
;= %SystemRoot%\system32\doskey /listsize=1000 /macrofile=%0%
;= rem In batch mode, jump to the end of the file
;= goto:eof
;============ Add aliases below here ============
open=explorer $*
clear=cls
vi=nvim $*
gl=git log --oneline --all --graph --decorate  $*
;= rem ls=lsd --icon never $*
;= rem l=lsd -l --icon never $*
;= rem la=lsd -a --icon never $*
;= rem lla=lsd -la --icon never $*
;= rem lt=lsd --tree --icon never $*
ls=eza $*
ll=eza -lh --icons $*
la=eza -lah --icons $*
lt=eza --tree --icons $*
mv=coreutils mv $*
rm=coreutils rm $*
cp=coreutils cp $*
pwd=coreutils pwd
pon=set HTTP_PROXY=http://127.0.0.1:7890& set HTTPS_PROXY=http://127.0.0.1:7890& set ALL_PROXY=socks5://127.0.0.1:7890& echo [Clash] Terminal Proxy ON (Port: 7890)
poff=set HTTP_PROXY=& set HTTPS_PROXY=& set ALL_PROXY=& echo [Clash] Terminal Proxy OFF
pstat=echo HTTP:  %HTTP_PROXY% & echo HTTPS: %HTTPS_PROXY% & echo ALL:   %ALL_PROXY%
