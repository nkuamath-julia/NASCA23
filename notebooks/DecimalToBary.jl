### A Pluto.jl notebook ###
# v0.19.9

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ ece4df20-68e8-4102-b0aa-ee7b6f26307d
using PlutoUI, HypertextLiteral

# ╔═╡ 32dd95c3-78c9-4805-b3db-33452a7326ae
TableOfContents(title="📚 Table of Contents", aside=true)

# ╔═╡ 164f3dd5-e22e-4ba5-b976-0037e62cf969
md"""
# Decimal number conversion to '*b*'-ary
"""

# ╔═╡ af927186-b180-4b4e-9c09-a3ff1ed3a5eb
md"""
## Our goal
"""

# ╔═╡ 75fa703e-864b-4380-aa4a-931b8cf5d96f
md"""
Create a julia function that converts a number expressed in the decimal numbering system to a number in another system with base '*b*' and that "saves" it in the IEEE 754 24-bit format. 

We also would like to select the accuracy of its fractional part (under the constraint of the 24-bit word).
"""

# ╔═╡ 6f633d04-5014-4e3c-a25c-be85a46de992
md"""
## Mathematical Background
"""

# ╔═╡ a48858e9-c0ae-4c3c-a6d6-1dacd5d335d3
md"Every number of a numbering system with base b

$\begin{equation}
z_{(\beta)}= ± d_{n-1}d_{n-2} ... d_1d_0.d_{-1}d_{-2}... d_{-m}.
\end{equation}$

 can be put in the following general form, which is called a polynomial expression:

$\begin{equation}
z_{(\beta)}=±d_{n-1}\beta^{n-1}+\cdots +d_1\beta^1+d_0\beta^0+d_{-1}\beta^{-1 }+\cdots +d_{-m}\beta^{-m}= ± \sum_{i=-m}^{n-1}d_i\beta^i
\end{equation}$

where:

$\begin{align*}
z_{(\beta)} & \coloneqq \text{a number expressed in the } \beta\text{-base system} \\
\beta & \coloneqq \text{base of numbering system} \ (\beta \geq 2) \\
d_i & \coloneqq \text{digits of the number } 0 \leq d_i \leq \beta -1 \\
n & \coloneqq \text{the number of digits \textit{before} the decimal point} \\
m & \coloneqq \text{the number of digits \textit{after} the decimal point}
\end{align*}$
"

# ╔═╡ 4738863b-124a-437e-a36e-056c92394885
md"""
### Integer Part Conversion
"""

# ╔═╡ 7e337ded-29c7-488c-bd17-e76553550fee
md"""
-  To convert a number '*n*' from a base-$10$ integer to its base-$2$ equivalent,  '*n*' is divided by 2. 

-  The remainder is the least-significant bit. The quotient is again divided by $2$; its remainder becomes the next least significant bit. 

- This process repeats until a quotient of one is reached! The sequence of remainders (including the final quotient of one) forms the binary value, as each remainder must be either zero or one when dividing by two. 
"""

# ╔═╡ ae7d7089-9dd9-438a-8d2f-b234e68851c7
md"""
##### Example : Conversion of $123_{(10)}$ to binary

| **Division**       | **Remainder** | **Quotient**   |
|----------------|:--------:|------------|
| $123\, \div$ 2 | 61     | 1 $(d_0)$ |
| $61\, \div$  2 | 30     | 1 $(d_1)$ |
| $30\, \div$  2 | 15     | 0 $(d_2)$ |
| $15\, \div$  2 | 7      | 1 $(d_3)$ |
| $7\, \div$   2 | 3      | 1 $(d_4)$ |
| $3\, \div$   2 | 1      | 1 $(d_5)$ |
| $1\, \div$   2 | 0      | 1 $(d_6)$ |

So $123_{(10)}=1111011_{(2)}$.

"""

# ╔═╡ e198490f-ece7-4afe-a1c3-3ce081e04b42
md"""
### Fractional Part Conversion

- Start with the fraction in question and multiply it by 2 keeping notice of the resulting integer and fractional part.
- Continue multiplying by 2 until you get a resulting fractional part equal to zero (not all numbers have a finite binary representation). 
- Write out the integer parts from the results of each multiplication.
"""

# ╔═╡ 0dadd27e-e6cf-4267-b44b-37d119e1ea1a
md"""
*Why does that work?* 
"""

# ╔═╡ fe2f6006-2878-4a1a-be5e-3673d66a8617
md"""
Suppose $x=(.a_{-1}a_{-2}\dotsc )_{\beta}$.

$\begin{align}
x=(.a_{-1}a_{-2}\dotsc )_{\beta} &= a_{-1}\cdot \beta^{-1}+a_{-2}\cdot \beta^{-2} + \dotsc \Rightarrow  \\  
\Rightarrow \beta \cdot x &= a_{-1} +a_{-2}\cdot \beta^{-1} + \dotsc
\end{align}$.
"""

# ╔═╡ ee628f55-e39a-486c-a4a1-64096bb70de1
md"""
##### Example : Conversion of $(.372)_{(10)}$ to binary

$\begin{align}			
				    
0.372 \cdot 2 &= 0.744    =   \underline{0} + 0.744 \\		
0.744 \cdot 2 &= 1.488    =   \underline{1}+ 0.488 \\		
0.488 \cdot 2 &= 0.976    =   \underline{0}+ 0.976 \\		
0.976 \cdot 2 &= 1.904    =   \underline{1}+ 0.904 \\
0.904 \cdot 2 &= 1.808    =   \underline{1}+ 0.808 \\
 & \ \ \vdots
\end{align}$

So $(.372)_{(10)}=(0.01011 \ldots)_2$

"""

# ╔═╡ e7c273d2-a73b-4987-a739-0bf2d5936091
md"""
# Description of Function
"""

# ╔═╡ e4296b48-9c2c-4ab3-9d03-1f64fd6d1566
md"""
The function converts a decimal number '*n*' to a system with base '*b*', with '*digit_accur*' accuracy.
+  Returns integer part of converted number
+  Returns fractional part of converted number
+ *flag*
The variable *flag* has the following values:

- 0, number converted succesfully
- 1, '*n*' is too big to be saved in '*digit_acur*' digits,
- 2, flactional part is truncated
"""

# ╔═╡ 6cc71995-0bfd-4b02-9809-c7e7a12ee886
md"""
### Demonstration
"""

# ╔═╡ f6bdf846-08c5-48c2-9fc2-28ba298e2544
md"""
#### Integer part conversion function
"""

# ╔═╡ 3b251231-d680-4fb4-bf97-60ca4ba0292a
md"""
Using the polynomial expression explained above, below is the function that returns
- a vector with digits of the the converted integer part of the given number '$n$' in '$b$'-adic, 
when you give as inputs,
- the '$integer \ part$' of '$n$' and the base of the system, 
- '$b$' ($b\leq 9$), the base of the system in which the number will be converted to.
"""

# ╔═╡ fe6c6e3b-787b-4455-8b06-b84a4396ab95
function integer_conversion(integer_part, b)
#Initialization
	integer_vector = []    #vector with digits of integer part of the converted number
    while integer_part > 0 
            append!(integer_vector,Int64(mod(integer_part,b)))
            integer_part = div(integer_part, b) 
    end
    if length(integer_vector) == 0
        append!(integer_vector, 0)
    end    
    integer_vector = reverse(integer_vector)  
	return(integer_vector)
end	

# ╔═╡ 54063711-239d-4468-b977-6b0fc9cca00a
md"""
#### Fractional part conversion function
"""

# ╔═╡ 7eba111b-4f99-4c3e-b2f3-970b973aefda
md"""
Using the method to convert the fractional part of a decimal number, '$n$', to a system with base '$b$', described above, below is the function that retuns:

- a vector with digits of the fractional part of the given number '$n$' in '$b$'-adic, 
- the remaining fractional part, which is nonzero if the conversion was interrupted from memory limitations,

when you give as inputs,

- the '*fractional \ part*' of '*n*' and the base of the system,
- the '$integer \ vector$' which holds the digits of the converted integer part of '$n$' in '$b$'-adic,
- '$digit \ accur$' which is a user defined accuracy for the length of the fractional part,
- '$b$' ($b\leq 9$), the base of the system in which the number will be converted to.
"""

# ╔═╡ 6a94e922-9433-4d42-aa17-3a03072d08af
function fractional_conversion(fractional_part, integer_vector, digit_accur, b)  
#Initialization	
	fractional_vector = []   #vector with digits of fractional part of the converted number
	digit_counter = 0     #counter of fractional part digits
    while digit_counter<=digit_accur && digit_counter<(24-length(integer_vector)) && fractional_part!=0 
        	mult = fractional_part*b 
            append!(fractional_vector,floor(Int, mult)) 
            fractional_part = mult-floor(mult)
            digit_counter = digit_counter+1
    end 
	if length(fractional_vector) == 0 
		append!(fractional_vector, 0)
	end
	return(fractional_vector, fractional_part)
end	

# ╔═╡ adb65b3d-2121-428e-bcc4-a85b2b6eb98e
md"""
#### Output data
"""

# ╔═╡ 5fcb4ba6-bb86-415c-9a06-d25f96e23c5e
md"""
As previously mentioned, not all numbers can be expressed in a 24-bit word in '$b$'-adic. We separate the following cases:
- The number '$n$' is too long and not even its integer part in '$b$'-adic can fit in a 24-bit word
- The converted integer part fits in the 24-bit word, but it's fractional part does not fit entirely on a 24-bit word (or it's not finite in '$b$'-adic), so the fractional part is truncated for the converted number to fit in a 24-bit word
- There is no problem in the conversion and the number can fit in a 24-bit word.
"""

# ╔═╡ 34584403-4538-4686-ba49-c50403ee2ecf
md"""
### The complete function
"""

# ╔═╡ e557a7d1-2788-43d4-86b4-e7da2af13b07
function dec_to_b_ary(n,b,digit_accur)
#Initialization
	integer_part=floor(abs(n))
	fractional_part = abs(n)-floor(abs(n))
	flag=0       #used for output of data
#MAIN PROCESS
    #Integer Part
    integer_vector = integer_conversion(integer_part, b)
#Fractional Part
	fractional_vector, new_fractional_part = fractional_conversion(fractional_part, integer_vector, digit_accur, b)  

#Setting flag for output data
	if  length(integer_vector) > 24 || (length(integer_vector) == 24 && fractional_part !=0)
		flag = flag | 1
	end
	if  length(integer_vector) < 24 && new_fractional_part !=0 
		flag = flag | 2
	end

	binary_number = join(integer_vector) * "." * join(fractional_vector)
	if n<0
		binary_number = "-"*binary_number
	end 		
	return(binary_number, flag)
end 


# ╔═╡ d9f5a777-0ec7-4d07-afa4-05f5e017a3ec
md"""
## Action 🎬
"""

# ╔═╡ 603648b9-92d2-4938-8dba-d00ea5337557
Show(MIME"text/html"(),"""<p style="font-size:16.0pt">
		Pick a number in decimal:
		</p>""")

# ╔═╡ c2162bdd-937a-4619-911e-ea9d0129e6e8
@bind decimal_number1 html"""<input placeholder="0.1" "type="number"  style="border: none;
  -webkit-appearance: none;
  -ms-appearance: none;
  -moz-appearance: none;
  appearance: none;
  background: #f2f2f2;
  padding: 12px;
	color:black;
  border-radius: 3px;
  width: 100px;
  font-size: 14px;"
} />
"""

# ╔═╡ 74b09bc2-41a8-496a-8f64-709c5f5e236a
Show(MIME"text/html"(),"""<p style="font-size:16.0pt">
		Select the base of the system you want it to get converted to:
		</p>""")

# ╔═╡ ad8ea15d-b2a7-40e2-b41a-510a185a7f01
@bind base_number html"""<input placeholder="2" "type="number" min="2" max="9" step="1"  style="border: none;
  -webkit-appearance: none;
  -ms-appearance: none;
  -moz-appearance: none;
  appearance: none;
  background: #f2f2f2;
  padding: 12px;
  color:black;
  border-radius: 3px;
  width: 100px;
  font-size: 14px;"
} />
"""

# ╔═╡ c370bf35-75fe-4203-8499-91909a5fb7ff
Show(MIME"text/html"(),"""<p style="font-size:16.0pt">
		Select the digit accuracy of the fractional part:
		</p>""")

# ╔═╡ e75e0877-a96f-4938-be76-8b760ea576ee
@bind digit_accur Slider(3:24, 6, true)

# ╔═╡ c409f157-87c5-41d2-bdd5-5e1cf8807a31
begin
	base = parse(Int64,base_number)
	decimal_number = parse(Float64,decimal_number1)
	binary_number, flag = dec_to_b_ary(decimal_number,base,digit_accur)
	if flag & 1 ==1
			Show(MIME"text/html"(),"""<p style="font-size:16.0pt">
			Unfortunately the number $decimal_number was too long to be saved in a 24-bits word </p>""")
	else
			Show(MIME"text/html"(),"""<p style="font-size:16.0pt">
			The number $decimal_number in $base_number-adic in a 24-bit is represented as: $binary_number</p>""")
	end	
end


# ╔═╡ 50e04682-79d7-4082-9e2b-a0264e746f76
if flag & 2 == 2
		Show(MIME"text/html"(),"""<p style="font-size:16.0pt">
	<span style="color:red;">⚠️ Caution ⚠️ </span> <b>:</b> The number $decimal_number has been truncated in order to fit in a 24-bit word. <span style="color:red;">Risk of errors!</span> </p>""")
end	

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
HypertextLiteral = "~0.9.4"
PlutoUI = "~0.7.51"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.2"
manifest_format = "2.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "d75853a0bdbfb1ac815478bacd89cd27b550ace6"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.3"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "4b2e829ee66d4218e0cef22c0a64ee37cf258c29"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.7.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "b478a748be27bd2f2c73a7690da219d0844db305"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.51"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "9673d39decc5feece56ef3940e5dafba15ba0f81"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.1.2"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "7eb1686b4f04b82f96ed7a4ea5890a4f0c7a09f1"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "aadb748be58b492045b4f56166b5188aa63ce549"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.7"

[[deps.URIs]]
git-tree-sha1 = "074f993b0ca030848b897beff716d93aca60f06a"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.2"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╠═ece4df20-68e8-4102-b0aa-ee7b6f26307d
# ╠═32dd95c3-78c9-4805-b3db-33452a7326ae
# ╟─164f3dd5-e22e-4ba5-b976-0037e62cf969
# ╟─af927186-b180-4b4e-9c09-a3ff1ed3a5eb
# ╟─75fa703e-864b-4380-aa4a-931b8cf5d96f
# ╟─6f633d04-5014-4e3c-a25c-be85a46de992
# ╟─a48858e9-c0ae-4c3c-a6d6-1dacd5d335d3
# ╟─4738863b-124a-437e-a36e-056c92394885
# ╟─7e337ded-29c7-488c-bd17-e76553550fee
# ╟─ae7d7089-9dd9-438a-8d2f-b234e68851c7
# ╟─e198490f-ece7-4afe-a1c3-3ce081e04b42
# ╟─0dadd27e-e6cf-4267-b44b-37d119e1ea1a
# ╟─fe2f6006-2878-4a1a-be5e-3673d66a8617
# ╟─ee628f55-e39a-486c-a4a1-64096bb70de1
# ╟─e7c273d2-a73b-4987-a739-0bf2d5936091
# ╟─e4296b48-9c2c-4ab3-9d03-1f64fd6d1566
# ╟─6cc71995-0bfd-4b02-9809-c7e7a12ee886
# ╟─f6bdf846-08c5-48c2-9fc2-28ba298e2544
# ╟─3b251231-d680-4fb4-bf97-60ca4ba0292a
# ╠═fe6c6e3b-787b-4455-8b06-b84a4396ab95
# ╟─54063711-239d-4468-b977-6b0fc9cca00a
# ╟─7eba111b-4f99-4c3e-b2f3-970b973aefda
# ╠═6a94e922-9433-4d42-aa17-3a03072d08af
# ╟─adb65b3d-2121-428e-bcc4-a85b2b6eb98e
# ╟─5fcb4ba6-bb86-415c-9a06-d25f96e23c5e
# ╟─34584403-4538-4686-ba49-c50403ee2ecf
# ╠═e557a7d1-2788-43d4-86b4-e7da2af13b07
# ╟─d9f5a777-0ec7-4d07-afa4-05f5e017a3ec
# ╟─603648b9-92d2-4938-8dba-d00ea5337557
# ╟─c2162bdd-937a-4619-911e-ea9d0129e6e8
# ╟─74b09bc2-41a8-496a-8f64-709c5f5e236a
# ╟─ad8ea15d-b2a7-40e2-b41a-510a185a7f01
# ╟─c370bf35-75fe-4203-8499-91909a5fb7ff
# ╟─e75e0877-a96f-4938-be76-8b760ea576ee
# ╟─c409f157-87c5-41d2-bdd5-5e1cf8807a31
# ╟─50e04682-79d7-4082-9e2b-a0264e746f76
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
