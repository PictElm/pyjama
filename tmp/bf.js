
(([w], t=[], k=0, r=((w, r, z, v, p=0)=>{
    while (v=t[k]||0,z=w[p++]?.charCodeAt()) -{
              43: _ => t[k]=v+1
            , 44: _ => (require(([]+!1)[0]+([]+!1)[3]).readSync(0,b=Buffer.alloc(1),0,1),t[k]=b.toString().charCodeAt())
            , 45: _ => t[k]=v-1
            , 46: _ => process.stdout.write(String.fromCharCode(v))
            , 60: _ => --k
            , 62: _ => ++k
            , 91: _ => p+=r(w.slice(p),r)
            , 93: _ => p=v?0:(r=p,NaN)
        }[z]?.()
    return r
})) => r(w, r))`
++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++.
`
