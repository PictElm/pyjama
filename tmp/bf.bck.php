
<?php ob_start()?>
++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++.
<?php
$k = 0;
$t = [];
($r = function($w, $r, $p=0) use(&$k, &$t) {
    while($p<strlen($w)){
        $v=@$t[$k];
        switch(ord($w[$p++])){
            case 43: $t[$k]=$v+1; break;
            case 44: $t[$k]=ord(fgetc(STDIN)); break;
            case 45: $t[$k]=$v-1; break;
            case 46: echo chr($v); break;
            case 60: $k++; break;
            case 62: $k--; break;
            case 91: $p+=$r(substr($w,$p),$r); break;
            case 93: if(!$v)return$p;$p=0; break;
        }
    }
})(ob_get_clean(),$r);
?>
