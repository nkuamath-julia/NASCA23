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

# ╔═╡ 1a950180-21cc-11ee-0a6f-8b943120c3a1
using PlutoUI, HypertextLiteral

# ╔═╡ 3c0d0396-8947-401b-b690-853c0e75ae0d
TableOfContents(title="📚 Table of Contents", aside=true, depth=4)

# ╔═╡ e974f6f0-c105-4c5f-86f0-2a69118e6ee9
md"""
# Decimal to binary conversion & saving in selected formats

## Our goal

Our main goal is to introduce saving formats of binary numbers in computers.

Specifically, this notebook aims to give the user the opportunity to select both a decimal number which will be converted to binary and the format in which it will be saved. The user will be able to choose the following formats:

* Fixed-point 24-bits
* IEEE 754 32-bits
* IEEE 754 64-bits

"""

# ╔═╡ bdecfc25-3b6b-4827-b64a-260c464346d9
md"""
**Assuming that you know how decimal to binary conversion is done** (otherwise check toggle button below), we will introduce the aforementioned saving formats. 
"""

# ╔═╡ 0e887e90-dfc5-4320-8e95-9e082086a778
details(x, summary="Show more") = @htl("""
	<details>
		<summary>$(summary)</summary>
		$(x)
	</details>
	""")

# ╔═╡ 66d71798-2d03-4192-885a-fdade970c7de
md"""
---
"""

# ╔═╡ e8aef948-7698-4236-8005-47a13df79284
details(md"""
---
## Decimal to Binary Conversion

Every number of a numbering system with base $\beta$

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


### Integer Part Conversion

-  To convert a number $n$ from a base-$10$ integer to its base-$\beta$ equivalent,  $n$ is divided by $\beta$. 

-  The remainder is the least-significant bit. The quotient is again divided by $\beta$; its remainder becomes the next least significant bit. 

- This process repeats until a quotient  smaller than $\beta$ is reached! The sequence of remainders (including the final quotient) forms the $\beta$-ary value.

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

### Fractional Part Conversion

- Start with the fraction in question and multiply it by $\beta$ keeping notice of the resulting integer and fractional part.
- Continue multiplying by $\beta$ until you get a resulting fractional part equal to zero (not all numbers have a finite $\beta$-ary representation). 
- Write out the integer parts from the results of each multiplication.

##### *Why does that work?*

Suppose $x=(.a_{-1}a_{-2}\dotsc )_{\beta}$.

$\begin{align}
x=(.a_{-1}a_{-2}\dotsc )_{\beta} &= a_{-1}\cdot \beta^{-1}+a_{-2}\cdot \beta^{-2} + \dotsc \Rightarrow  \\  
\Rightarrow \beta \cdot x &= a_{-1} +a_{-2}\cdot \beta^{-1} + \dotsc
\end{align}$.

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

---
"""
,"Click to see mathematical background behind Decimal to Binary conversion")


# ╔═╡ 9eafa347-0823-4f38-8abd-482e3eb71410
md"""
---
"""

# ╔═╡ 9f0749a8-f72f-4d37-add1-bec21a32921c
md"""
## Saving formats - Theoretical Background
"""

# ╔═╡ 44aefb24-bd8f-42f8-a9d7-35d88d79ba71
md"""
### Fixed-point 24 bits

In a $24$-bit fixed-point representation, numbers are stored using a **fixed** number of bits. Here's how a binary number is typically saved in a $24$-bit fixed-point format:

- Sign Bit: The leftmost bit is typically used as the sign bit & $0$ denotes a positive number whereas $1$ denotes a negative number.
- Integer Part: The following bits are used to represent the integer part of the number. 
❗️If the length of the binary representation of the integer part is longer than 23 bits, the result is typically truncated or wrapped around, resulting in an incorrect value. 

- Fractional Part: The remaining bits are used to represent the fractional part of the number.
"""

# ╔═╡ dc8214e2-35af-487a-b85a-7881738dcb6f
md"""
### IEEE 754 32-bit format (64-bit format) 
In the IEEE $754$ $32$-bit format ($64$-bit format), binary numbers are stored using a specific arrangement of bits to represent the sign, exponent, and significand (also known as mantissa). Here's a breakdown of how a binary number is typically saved in the IEEE $754$ $32$-bit format ($64$-bit format:

- Sign Bit: The leftmost bit is used as the sign bit & $0$ denotes a positive number whereas $1$ denotes a negative number.
- Exponent Bits: The following $8$ bits ($14$ in $64$-bit format), are used to represent the exponent. The exponent is biased by a constant value, $127$ in $32$-bit format ($1023$ in $64$-bit format). The actual exponent is calculated by interpreting the exponent bits as an unsigned integer.
- Significand Bits (Mantissa): The remaining bits mantissa of the number. The significand represents the fractional part of the number in normalized scientific notation, typically with an implicit leading bit (known as the hidden bit) that is always assumed to be $1$. 
"""

# ╔═╡ 4e59e76c-1042-4ccb-87bb-ef37c59e7a95
md"""
## Description of functions
"""

# ╔═╡ 187a5100-f22f-4bfc-88ac-f3b303b41765
md"""
### Main functions
"""

# ╔═╡ 867199f0-3a6e-4048-a191-bb87736b1ede
md"""
#### Integer part conversion function

Using the polynomial expression of number $n$, below is the function that returns,
- a string with digits of the the converted integer part of the given number '$n$' in binary, 
when given,
- the '_integer part_' of $n$. 

"""

# ╔═╡ 7c34725f-03c5-4c44-8565-bb9f3169cd64
function integer_conversion(integer_part::Int64)
#Initialization
	integer_string = "" #string with digits of integer part of the converted number
#Main process	
    while integer_part > 0 
			integer_string = string(Int64(mod(integer_part,2))) * integer_string
            integer_part = div(integer_part, 2) 
    end
    if length(integer_string) == 0
		integer_string = "0"
    end    
	return(integer_string)
end	

# ╔═╡ f6d752c1-cbf0-42e5-b99a-c4ac9cc59ced
md"""
#### Fractional part conversion function

Using the method to convert the fractional part of a decimal number, '$n$', to binary below is the function that retuns:

- a string with digits of the fractional part of the given number '$n$' in binary with at most $digit\_accur$ digits

when you give as inputs,

- the '_fractional part_' of $n$,
- a bound for the length of the binary fractional part, $digit\_accur$.
"""

# ╔═╡ f902cc64-6838-46b2-9139-29a4586bb27c
function fractional_conversion(decimal_fractional::Float64, digit_accur::Int64)
#Initialization
	binary_fractional_string = "" #string with digits of fractional part of the converted number
#Main process	
    while length(binary_fractional_string)<digit_accur && decimal_fractional!=0
		mult = decimal_fractional*2 #only used for our ease
        binary_fractional_string *= string(floor(Int, mult))
        decimal_fractional = parse(Float64,string(mult)[2:end])#to avoid subtraction 
    end    
	truncated = decimal_fractional == 0 ? 0 : 1
	return(binary_fractional_string::String,truncated)
end

# ╔═╡ cb8cd5b9-8978-4d8e-b147-a6f338fa79bb
md"""
#### Fixed-point 24 bits

Using the method to save a binary number in Fixed-point $24$ bits format the function returns:

- the binary representation of the given decimal number,
- a flag, '_truncated_', which is used to inform user about truncation errors

when you give as inputs,

- the decimal_number, $n$, you would like to convert to binary.
"""

# ╔═╡ b82a5d2a-f7b0-4ae4-92b5-2156e4a0726c
md"""
#### Ieee Function

Using the method to save a binary number in the IEEE $754$ format $32$ (or $64$)-bits, the function returns:

- the binary representation in IEEE $754$  $32$ (or $64$)-bit format,
- a flag, '_truncated_', which is used to inform user about truncation errors,

when you give as inputs,

- the decimal_number, $n$,
- the number of the mantissa bits ($23$ for $32$-bit format & $52$ for $64$-bit format),
- the bias for the exponent  ($127$ for $32$-bit format & $1023$ for $64$-bit format).
"""

# ╔═╡ 41076717-db60-4c91-8ae3-149afd705a3e
md"""
### Helping functions
"""

# ╔═╡ 12487f9e-9b9c-4b2b-9013-103025eef6f6
md"""
#### Function splitnum(n)

The 'splitnum(n)' function splits a number $n$ into its integer and fractional parts and returns them as separate values. 

❗️If the input number is an integer without a decimal point, the function adds "$.0$" to convert it into a decimal representation.
"""

# ╔═╡ fc16c4d8-d969-4acc-ac9d-8fab266b4432
function splitnum(n::String)
    if '.'  ∉ n #integer
        n = n * ".0"
    end
    dotindex = findfirst('.', n)
    integer_part = n[1:dotindex-1] 
    fractional_part = "0." * n[dotindex+1:end] 
    return parse(Int64,integer_part), parse(Float64,fractional_part)
end

# ╔═╡ ebace5f0-885b-4126-a884-5047f4de5e2c
md"""
#### Function fill\_with\_zero

The function fill\_with\_zero(fractional\_string, n) takes as inputs:

- a fractional string, 
- a target length $n$. 

It fills the fractional string with leading zeros (if necessary) to match the target length $n$ and returns the result.
"""

# ╔═╡ e18186e2-3dd1-4cd0-bd39-e9ba17f3cc60
function fill_with_zero(fractional_string::String, n::Int64)
    if length(fractional_string) < n
        diff = n - length(fractional_string)
        for i in 1:diff
            fractional_string *= '0' #fill with zeroeeees
        end
    end
    return fractional_string
end

# ╔═╡ ac5019b0-910d-4cd7-9f21-e43d041afcda
function fixed_point_24(decimal_number::String)
#Initialization
	decimal_integer_part, decimal_fractional_part = splitnum(decimal_number)
	sign_bit = decimal_integer_part < 0 ? "1" : "0"
	flag=0       #used for output of data
#MAIN PROCESS
    #Integer Part
    integer_string = integer_conversion(abs(decimal_integer_part))
	if length(integer_string) >= 24
		truncated = 1
		binary_number = nothing
	else #if not even integer part can fit inside 	
	#Fractional Part
		fractional_string, truncated = fractional_conversion(decimal_fractional_part,23-length(integer_string))
		if length(integer_string)+length(fractional_string) < 23
	            fractional_string = fill_with_zero(fractional_string, 23-length(integer_string))
	    end
		binary_number = sign_bit * "|" * integer_string * "|" * fractional_string
	end
	truncated = truncated == 1 ? "truncated" : "not truncated";
	return(binary_number, truncated)
end 


# ╔═╡ e31652c7-8ffb-4c9b-9e66-2540c852095b
md"""
#### Function ieee\_zero\_integer

- The function ieee\_zero\_integer(decimal\_fractional\_part) is for normalizing decimal numbers with integer part being $0$ in order to save their binary representation in IEEE $754$ format with $32$ or $64$ bits. It works as following:

- Applies decimal to binary conversion in the fractional part until it finds a nonzero binary digit. 

- Skips fractional bits which are $0$, until if finds the first nonzero fractional bit. At that point, it returns the exponent and the decimal fractional part to allow the function 'ieee' to perform the rest of conversion of the binary fractional part.
"""

# ╔═╡ 61b2c145-5205-43ec-a55f-f2834ddafdf8
function ieee_zero_integer(decimal_fractional_part)
	mult = decimal_fractional_part*2 
	decimal_fractional_part = mult-floor(mult)
	exponent_decimal = 0
	while floor(mult) == 0
		exponent_decimal += 1
		mult = decimal_fractional_part*2 
		decimal_fractional_part = mult-floor(mult)
	end	  
	return(exponent_decimal,mult)
end

# ╔═╡ fee54a51-db4b-4e05-8b6b-9ad176984b4a
function ieee(decimal_number::String, mantissa_bits::Int64, bias::Int64)
#Split decimal number in fractional and decimal part & defining sign bit	
	decimal_integer_part, decimal_fractional_part = splitnum(decimal_number)
	sign_bit = decimal_integer_part < 0 ? "1" : "0"
#	
	if abs(decimal_integer_part) >=1 # integer part is non-zero
		integer_string = integer_conversion(abs(decimal_integer_part))
		mantissa = integer_string[2:length(integer_string)] #initialize mantissa with integer part
	# exponent definition 
		exponent_decimal = length(integer_string)-1
		biased_exponent_binary = integer_conversion(exponent_decimal + bias)
	#fill remaining space in mantissa with bits from fractional part
 		fractional_string, truncated = fractional_conversion(decimal_fractional_part, mantissa_bits-length(mantissa))
		mantissa = mantissa * fractional_string
	else #integer part zero
		exponent_decimal, mult = ieee_zero_integer(decimal_fractional_part) #apply conversion to fractional part until you find nonzero binary digit
		biased_exponent_binary = integer_conversion(exponent_decimal + bias)
		mantissa, truncated = fractional_conversion(mult/2, mantissa_bits) 
	end		
	#fix mantissa length
	if length(mantissa) < mantissa_bits 
            mantissa = fill_with_zero(mantissa, mantissa_bits)
	elseif length(mantissa) > mantissa_bits 
		mantissa = mantissa[1:mantissa_bits]
	end	
	# put it all together
	binary_number = sign_bit * "|" * biased_exponent_binary * "|" * mantissa
	truncated = truncated == 1 ? "truncated" : "not truncated";
	return(binary_number, truncated)
end

# ╔═╡ 69abfe35-e89e-439b-98e3-7e24558b7af0
md"""
## Action🎬
"""

# ╔═╡ 8a43222a-835b-4425-857d-135d0a021998
Show(MIME"text/html"(),"""<p style="font-size:16.0pt">
		Pick a number in decimal:
		</p>""")

# ╔═╡ 739dfa26-4d0c-46fb-8fd1-be5df7c1d6f7
@bind decimal_number html"""<input placeholder="0.1" "type="number"  style="border: none;
  -webkit-appearance: none;
  -ms-appearance: none;
  -moz-appearance: none;
  appearance: none;
  background: #f2f2f2;
  padding: 12px;
	color:black;
  border-radius: 3px;
  width: 150px;
  font-size: 14px;"
} />
"""

# ╔═╡ 470a598e-aa4b-4a36-a02d-0ff8e521d40a
Show(MIME"text/html"(),"""<p style="font-size:16.0pt">
		Select the format(s) in which you want to save $decimal_number's binary representation.
		
	<br>
⚠️ <span style="color:red;">Caution:</span> In order to avoid app crashes when chaning the decimal number, unselect all selections below <i>before changing the decimal number!</i>	
</p>
""")

# ╔═╡ 35950a8d-fc32-4210-8540-e0481b1a8ff6
begin
	fixed_point_checkbox = @bind fixed html"<input type=Checkbox Unchecked>"
	
	ieee32_checkbox = @bind ieee32 html"<input type=Checkbox Unchecked>"
	
	ieee64_checkbox = @bind ieee64 html"<input type=Checkbox Unchecked>"
	
	md"""
	
	Fixed-point $24$-bits: $(fixed_point_checkbox)
	
	IEEE $754$ $32$-bits: $(ieee32_checkbox)
	
	IEEE $754$ $64$-bits: $(ieee64_checkbox)
	"""
end

# ╔═╡ dfea52b1-6aa4-43b2-b412-4518114695b9
md"""
---
"""

# ╔═╡ 541ac078-85c0-4308-b3e7-56619fd629c6
if fixed 
	binary_number24, truncated24 = fixed_point_24(decimal_number)
	if binary_number24 == nothing
		HTML("""
			<p style="font-size:20px">❗️The integer part of the binary representation of number $decimal_number can't fit in a fixed-point 24-bit format.
			""")
	else	
		if truncated24 == "truncated"
			HTML("""
			<li>
			<p style="font-size:20px">The binary representation of number $decimal_number in fixed-point 24-bit format is: <br>
			$binary_number24 (<span style="color:red;">$truncated24</span>)</p>
			</li>
			""")
		else
			HTML("""
			<li>
			<p style="font-size:20px">The binary representation of number $decimal_number in fixed-point 24-bit format is: <br>
			$binary_number24 (<span style="color:green;">$truncated24</span>)</p>
			</li>
			""")
		end
	end
end

# ╔═╡ 40fb77f6-00cf-4991-96f8-7e4b8d2e3f7b
if ieee64 
	binary_number64, truncated64 = ieee(decimal_number, 52,1023)
	if truncated64 == "truncated"
		HTML("""
		<li>
		<p style="font-size:20px">The binary representation of number $decimal_number in IEEE 754 64-bit format is: <br>
		$binary_number64 (<span style="color:red;">$truncated64</span>)</p>
		</li>
		""")
	else
		HTML("""
		<li>
		<p style="font-size:20px">The binary representation of number $decimal_number in IEEE 754 64-bit format is: <br>
		$binary_number64 (<span style="color:green;">$truncated64</span>)</p>
		</li>
		""")
	end
end 

# ╔═╡ 34270e61-26ca-4503-bdc6-fd2f7c9e8f15
if ieee32 
	binary_number32, truncated32 = ieee(decimal_number,23,127)
	if truncated32 == "truncated"
		HTML("""
		<li>
		<p style="font-size:20px">The binary representation of number $decimal_number in IEEE 754 32-bit format is: <br>
		$binary_number32 (<span style="color:red;">$truncated32</span>)</p>
		</li>
		""")
	else
		HTML("""
		<li>
		<p style="font-size:20px">The binary representation of number $decimal_number in IEEE 754 32-bit format is: <br>
		$binary_number32 (<span style="color:green;">$truncated32</span>)</p>
		</li>
		""")
	end
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
# ╠═1a950180-21cc-11ee-0a6f-8b943120c3a1
# ╠═3c0d0396-8947-401b-b690-853c0e75ae0d
# ╟─e974f6f0-c105-4c5f-86f0-2a69118e6ee9
# ╟─bdecfc25-3b6b-4827-b64a-260c464346d9
# ╟─0e887e90-dfc5-4320-8e95-9e082086a778
# ╟─66d71798-2d03-4192-885a-fdade970c7de
# ╟─e8aef948-7698-4236-8005-47a13df79284
# ╟─9eafa347-0823-4f38-8abd-482e3eb71410
# ╟─9f0749a8-f72f-4d37-add1-bec21a32921c
# ╟─44aefb24-bd8f-42f8-a9d7-35d88d79ba71
# ╟─dc8214e2-35af-487a-b85a-7881738dcb6f
# ╟─4e59e76c-1042-4ccb-87bb-ef37c59e7a95
# ╟─187a5100-f22f-4bfc-88ac-f3b303b41765
# ╟─867199f0-3a6e-4048-a191-bb87736b1ede
# ╠═7c34725f-03c5-4c44-8565-bb9f3169cd64
# ╟─f6d752c1-cbf0-42e5-b99a-c4ac9cc59ced
# ╠═f902cc64-6838-46b2-9139-29a4586bb27c
# ╟─cb8cd5b9-8978-4d8e-b147-a6f338fa79bb
# ╠═ac5019b0-910d-4cd7-9f21-e43d041afcda
# ╟─b82a5d2a-f7b0-4ae4-92b5-2156e4a0726c
# ╠═fee54a51-db4b-4e05-8b6b-9ad176984b4a
# ╟─41076717-db60-4c91-8ae3-149afd705a3e
# ╟─12487f9e-9b9c-4b2b-9013-103025eef6f6
# ╠═fc16c4d8-d969-4acc-ac9d-8fab266b4432
# ╟─ebace5f0-885b-4126-a884-5047f4de5e2c
# ╠═e18186e2-3dd1-4cd0-bd39-e9ba17f3cc60
# ╟─e31652c7-8ffb-4c9b-9e66-2540c852095b
# ╠═61b2c145-5205-43ec-a55f-f2834ddafdf8
# ╟─69abfe35-e89e-439b-98e3-7e24558b7af0
# ╟─8a43222a-835b-4425-857d-135d0a021998
# ╟─739dfa26-4d0c-46fb-8fd1-be5df7c1d6f7
# ╟─470a598e-aa4b-4a36-a02d-0ff8e521d40a
# ╟─35950a8d-fc32-4210-8540-e0481b1a8ff6
# ╟─dfea52b1-6aa4-43b2-b412-4518114695b9
# ╟─541ac078-85c0-4308-b3e7-56619fd629c6
# ╟─40fb77f6-00cf-4991-96f8-7e4b8d2e3f7b
# ╟─34270e61-26ca-4503-bdc6-fd2f7c9e8f15
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
