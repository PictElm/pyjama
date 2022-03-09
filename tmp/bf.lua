
w=[[
++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++.
]]

p,k,t=1,1,{}r={}
while p < #w do
    v=(t[k]or 0)z=string.byte(w,p)p=p+1
    if u then
            if 91 == z then u=u+1
        elseif 93 == z then u=0~=u and u-1
        end
    else
            if 43 == z then t[k]=v+1
        elseif 44 == z then t[k]=string.byte(io.read(1))
        elseif 45 == z then t[k]=v-1
        elseif 46 == z then io.write(string.char(v))
        elseif 60 == z then k=k-1
        elseif 62 == z then k=k+1
        elseif 91 == z then if 0~=v then r[#r+1]=p-1 else u=0 end
        elseif 93 == z then p,r[#r]=r[#r]
        end
    end
end
