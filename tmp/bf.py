
w = "+++.[-]."
r = []
print("\n".join(
    (
        " " * len(r) + {
            43: "t[k]+=1",
            44: "input()",
            45: "t[k]-=1",
            46: "print(t[k],end='')",
            60: "k-=1",
            62: "k+=1",
            91: "while t[k]:",
        }.get(ord(c), ""),
        print("coucou") if 91 == c else print("blabla") if 93 == c else print("bite")
        # 91 == c and print('r.append(0)') or 93 == c and r.pop()
    )[0]
    for c in w
))
