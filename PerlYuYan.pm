# $File: //member/autrijus/Lingua-Sinica-PerlYuYan/PerlYuYan.pm $ $Author: autrijus $
# $Revision: #2 $ $Change: 706 $ $DateTime: 2002/08/18 03:49:00 $

package Lingua::Sinica::PerlYuYan;
$Lingua::Sinica::PerlYuYan::VERSION = '0.03';

use strict;
use utf8;
use Filter::Simple;
use Encode;

=head1 NAME

Lingua::Sinica::PerlYuYan - Use Chinese to write Perl

=head1 SYNOPSIS

    #!/usr/local/bin/perl
    # The Sieve of Eratosthenes - 埃拉托斯芬篩法
    use Lingua::Sinica::PerlYuYan;

    用籌兮用嚴  井涸兮無礙。
    印曰最高矣  又道數然哉。
    截起吾純風  賦小入大合。
    習予吾陣地  並二至純風。
    當起段賦取  加陣地合始。
    陣地賦篩始  繫繫此雜段。
    終陣地兮印  正道次標哉。
    輸空接段點  列終註泰來。

=head1 DESCRIPTION

The B<Lingua::Sinica::PerlYuYan> makes it makes it possible to write
Perl programs in Chinese. (If you have to ask "Why?", please refer to
L<Lingua::Romana::Perligata> for related information.)

This module uses the single-character property of Chinese to disambiguate
between keywords, thus whitespaces could be omitted this way, much like
in real Chinese writings.

The vocabulary is of the I<WenYanWen> (文言文, literary text) mode,
not much used in modern Chinese, which prefers the I<BaiHuaWen>
(白話文, spoken text) mode with multiple-syllable words.

You could use C<Lingua::Sinica::PerlYuYan::translate()> (or simply
as C<譯()>) to translate a string containing English programs into
Chinese.

=head1 CAVEATS

Currently Big-5 only. UTF-8 and GB2312 support is trivial, and will be
available upon request.

=cut
our %Tab;
while (<DATA>) {
    $_ = Encode::decode_utf8( $_ );
    next if /^\s*$/;
    chomp; my $chi = <DATA>; chomp $chi;
    $chi =~ s/[a-z]+//ig;
    $chi =~ s/\s//g;
    @Tab{ $chi =~ /(.)/g } = map { /^[a-z]+$/ ? "$_ " : $_ } split( /[\s\t]/, $_ );
}

@Tab{qw/資曰     亂曰    檔曰     列曰     套曰/} = qw{
        __DATA__ __END__ __FILE__ __LINE__ __PACKAGE__
};

FILTER {
    $_ = Encode::decode_utf8($_);
    foreach my $key ( sort { length $b <=> length $a } keys %Tab ) {
        print "$key\n";
        s/$key/$Tab{$key}/g;
    }
    return $_;
};

sub translate {
    my $code = shift;

    foreach my $key (sort {length $Tab{$b} cmp length $Tab{$a}} keys %Tab) {
	$code =~ s/\Q$Tab{$key}\E/$key/g;
    }

    return $code;
}

1;

=head1 SEE ALSO

L<Filter::Simple>, L<Lingua::Romana::Perligata>.

=head1 AUTHORS

Autrijus Tang E<lt>autrijus@autrijus.orgE<gt>

=head1 COPYRIGHT

Copyright 2001, 2002 by Autrijus Tang E<lt>autrijus@autrijus.orgE<gt>.

This program is free software; you can redistribute it and/or 
modify it under the same terms as Perl itself.

See L<http://www.perl.com/perl/misc/Artistic.html>

=cut

__DATA__
a b c d e f g h i j k l m n o p q r s t u v w x y z
甲乙丙丁戊己庚辛壬癸子丑寅卯辰巳午未申酉戌亥地水火風
A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
青心赤肝黃脾白肺黑腎鼠牛虎兔龍蛇馬羊猴雞狗豬春夏秋冬

0 1 2 3 4 5 6 7 8 9 10 100 1000 10000 10000_0000
零一二三四五六七八九十 百  千   萬    億
0 1 2 3 4 5 6 7 8 9 10 100 1000 20 30
零壹貳毿肆伍陸柒捌玖拾 佰  仟   廿 卅
0 1 2 3 4 5 6 7 8 9
０１２３４５６７８９

! @ # # $ % % ^ & * ( ) - = _ + + [ ] { } \ | ; : : 
非陣井註純雜模析和乘起合減賦底加正內外始終參聯兮然標
' ' " " , , => < . . > / / ? ` ` ~
曰矣道哉又並與 小點接大除分歟行者繫
! @ # $ % ^ & * ( ) - = _ + [ ] { } \ | ; ; : ' " , , < . > / ? ` ~
！＠＃＄％︿＆＊（）－＝禳洁e〕｛｝╲｜；。：’”，、＜．＞╱？‵∼

.. ... ** ++ -- -> ::
至 乃  冪 增 扣 之 宗

&& == || and or lt gt cmp eq not
及 等 許 且  或 前 後 較  同 否

$/ $_ @_ "\x20" "\t" "\n" main
段 此 諸 空     格   列   主

STDIN STDOUT STDERR DATA BEGIN END INIT CHECK DESTROY
入    出     誤     料   創    末  育   察    滅

chomp chop chr crypt hex index lc lcfirst length oct ord pack q/ qq/ reverse
截    斬   文  密    爻  索    纖 細      長     卦  序  包   引 雙  逆      
rindex sprintf substr tr/ uc ucfirst y/
檢     編      部     轉  壯 厚      換 

m/ pos quotemeta s/ split study qr/
符 位  逸        代 切    習    規

abs atan2 cos exp hex int log oct rand sin sqrt srand
絕  角    餘  階  爻  整  對  卦  亂   弦  根   騷    

pop push shift splice unshift
彈  推   取    抽     予      

grep join map qw/ reverse sort unpack
篩   併   映  篇  逆      排   啟     

delete each exists keys values
刪     每   存     鍵   值     

binmode close closedir dbmclose dbmopen die eof fileno flock format getc
法      閉    關       閤       揭      死  結  號     鎖    排     擷
print printf read readdir rewinddir seek seekdir select syscall
印    輸     讀   readdir rewinddir 搜   seekdir 擇     喚
sysread sysseek syswrite tell telldir truncate warn write
sysread sysseek syswrite 告   telldir 縮       訊   寫

pack read syscall sysread syswrite unpack vec
包   讀   syscall sysread syswrite 啟     向 

chdir chmod chown chroot fcntl glob ioctl link lstat mkdir open opendir
目    權    擁    遷     控    全   制    鏈   lstat 造    開   opendir 
readlink rename rmdir stat symlink umask unlink utime
readlink 更     毀    態   symlink 蒙    鬆     utime 

caller continue die do dump eval exit goto last next redo return sub wantarray
喚     續       死  為 傾   執   離   躍   尾   次   重   回     副  欲        

caller import local my our package use
喚     導     域    吾 咱  套      用  

defined dump eval formline local my our reset scalar undef wantarray
定      傾   執   formline 域    吾 咱  抹    量     消    欲        

alarm exec fork getpgrp getppid getpriority kill
鈴    生   殖   getpgrp getppid getpriority 殺   

for
重

pipe qx/ setpgrp setpriority sleep system times wait waitpid
管   qx/ setpgrp setpriority 眠    作     計    候   waitpid 

do no package require use
為 無 套      必      用  

bless dbmclose dbmopen package ref tie tied untie
祝    dbmclose dbmopen 套      照  纏  縛   解

accept bind connect getpeername getsockname getsockopt listen recv send
受     縛   連      getpeername getsockname getsockopt 聆     收   送

setsockopt shutdown sockatmark socket socketpair 
setsockopt shutdown sockatmark 槽     socketpair 

msgctl msgget msgrcv msgsnd semctl semget semop shmctl shmget shmread shmwrite
msgctl msgget msgrcv msgsnd semctl semget semop shmctl shmget shmread shmwrite

endgrent endhostent endnetent endpwent getgrent getgrgid getgrnam
endgrent endhostent endnetent endpwent getgrent getgrgid getgrnam

getlogin getpwent getpwnam getpwuid setgrent setpwent 
getlogin getpwent getpwnam getpwuid setgrent setpwent 

endprotoent endservent gethostbyaddr gethostbyname
endprotoent endservent gethostbyaddr gethostbyname 

gethostent getnetbyaddr getnetbyname getnetent
gethostent getnetbyaddr getnetbyname getnetent 

getprotobyname getprotobynumber getprotoent
getprotobyname getprotobynumber getprotoent 

getservbyname getservbyport getservent sethostent
getservbyname getservbyport getservent sethostent 

setnetent setprotoent setservent
setnetent setprotoent setservent 

gmtime localtime time
準     區        時

attributes autouse base blib bytes charnames constant diagnostics encoding fields
性         活      基   括   字    名        常       診          碼       欄
filetest integer less locale overload sigtrap strict subs utf8 vars vmsish warnings
試       籌      少   國     載       號      嚴     式   通   變   倭     警
Lingua::Sinica::PerlYuYan::translate Lingua::Sinica::PerlYuYan::Tab
譯                                   表