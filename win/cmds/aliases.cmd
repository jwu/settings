;= @echo off
;= rem ls=ls --show-control-chars -F --color $*
;= rem Call DOSKEY and use this file as the macrofile
;= %SystemRoot%\system32\doskey /listsize=1000 /macrofile=%0%
;= rem In batch mode, jump to the end of the file
;= goto:eof
;============ Add aliases below here ============
e.=explorer .
clear=cls
vi=nvim $*
gl=git log --oneline --all --graph --decorate  $*
ls=lsd --icon never $*
l=lsd -l --icon never $*
la=lsd -a --icon never $*
lla=lsd -la --icon never $*
lt=lsd --tree --icon never $*
mv=coreutils mv $*
rm=coreutils rm $*
cp=coreutils cp $*
pwd=coreutils pwd
pon=set http_proxy=http://127.0.0.1:7890 & set https_proxy=http://127.0.0.1:7890 & set all_proxy=socks5://127.0.0.1:7890 & echo [Clash] Terminal Proxy ON (Port: 7890)
poff=set http_proxy= & set https_proxy= & set all_proxy= & echo [Clash] Terminal Proxy OFF
pstat=echo HTTP:  %http_proxy% & echo HTTPS: %https_proxy% & echo ALL:   %all_proxy%
