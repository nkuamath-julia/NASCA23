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

# ╔═╡ a9153295-77fc-4a37-95e0-a3585671f54d
using PlutoUI, HypertextLiteral, CalculusWithJulia

# ╔═╡ 34151786-af3d-4973-8d37-a324a60b6a83
TableOfContents(title="📚 Table of Contents", aside=true)

# ╔═╡ b49f4090-0052-4526-a73b-b754e454ec51
md"""
# Binary-rational numbers in $[a_{10}, b_{10}]$
"""

# ╔═╡ a0b35787-5bdd-4038-9871-820a72521386
md"""
## Description of the problem

The program will ask for $2$ numbers $a_{10},b_{10}(a_{10} < b_{10})   \in \mathbb{R}$ and will produce all the numbers in $[a,b]$ which have a finite binary representation (are rationals in the binary system) with a given number of digits in the fractional part.
"""

# ╔═╡ a7444b47-7922-46af-b071-e9e23a20d055
md"""
## The main idea

Having selected the maximum number of digits the fractional part of a binary-rational can have, called '$digits$', the main idea revolves around:
1. Convert the $2$ given numbers, $a$ and $b$, to binary.
2. Start from $a$ and iteratively add the smallest binary number(which satsfies the fractional part length restriction), this being $2^{-digits}$, till you get to $b$.

 By doing this, we will have all the binary-rational numbers between $a$ and $b$ with the desired maximum number of digits.

3. Convert the binary-rationals from step "2." to decimal to arrive to the desired result.
"""

# ╔═╡ 8fc457b5-4878-4326-8b73-3ed54a84d49b
md"""
### Possible problems & proposed fixes

 - If the small number, '$a$',  was truncated, we will start the process from the next one (by adding $2^{-digits}$ to $a$), because we don't want binary-rationals $<a$.
- We will manually simulate the addition of $2^{-digits}$, starting from $a$ till we reach $b$. If  $a$'s binary expression is finite with less that the maximum desired number of digits in its fractional part, we will fill $a$ with zeroes, in order to give it the maximum desired length.
"""

# ╔═╡ 0a5cdbb7-32c1-42d6-997a-4c47fc857f6e
md"""
## Description of functions used 
"""

# ╔═╡ 9771cb0d-8722-4fcd-a577-9b167997bad6
md"""
### Function: integer\_conversion(integer\_part)
The function below takes as input:

- the '_integer part_' of a decimal number
and *returns*:

- a string with digits of the the converted integer part of the given number '$n$' in binary, 
"""

# ╔═╡ 4c7eabef-886f-4ac0-8b19-7b9bc0632d72
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

# ╔═╡ df6ae140-cb67-4a5e-b2f4-a47987d58597
md"""
### Function: fractional\_conversion(decimal\_fractional, digit\_accur, give\_truncation\_data)



The function below takes as input:

- the '_fractional part_' of $n$,
- a bound for the length of the binary fractional part, $digit\_accur$.
- a boolean value, $give\_truncation\_data$, which when true, *returns* info about truncation of fractional part.

and *returns*:

- a string with digits of the the converted integer part of the given number '$n$' in binary.
"""

# ╔═╡ 799cb94f-fae8-48e5-aab5-b231748511a5
function fractional_conversion(decimal_fractional::Float64, digit_accur::Int64, give_truncation_data::Bool)
#Initialization
	binary_fractional_string = "" #string with digits of fractional part of the converted number
#Main process	
    while length(binary_fractional_string)<digit_accur && decimal_fractional!=0
		mult = decimal_fractional*2 #only used for our ease
        binary_fractional_string *= string(floor(Int, mult))
        decimal_fractional = parse(Float64,string(mult)[2:end])#to avoid subtraction 
    end    
	if give_truncation_data
		truncated = decimal_fractional == 0 ? 0 : 1
		return(binary_fractional_string::String,truncated)
	else	
		return(binary_fractional_string::String)
	end	
end

# ╔═╡ 19d9085b-0c90-405b-ac12-a3e3c5a0b654
md"""
### Function: decimal\_to\_binary\_fractional(fractional\_part, digit\_accur)

The function below takes as *inputs*
- The fractional part of a decimal number,
- A natural number which represents the digits of the fractional part of the binary representation of the inputed number.

and *returns*:
- a string with the fractional part of the binary representation
"""

# ╔═╡ 7ec2d89b-316e-4057-8070-283bd38be577
function decimal_to_binary(n,digit_accur)
    #Initialization
    integer_part=Int(floor(abs(n)))
    fractional_part = abs(n)-floor(abs(n))
    #MAIN PROCESS
    #Integer Part
    integer_string = integer_conversion(integer_part)
    #Fractional Part
    fractional_string = fractional_conversion(fractional_part, digit_accur,false)  
    binary_number = integer_string * "." * fractional_string
    if n<0
        binary_number = "-"*binary_number
    end 		
    return(binary_number)
end 

# ╔═╡ 4935107a-bebb-4404-b364-16165ad9a832
md"""
### Function: binary\_to\_decimal(binary)

The function below takes as *inputs*
- A binary number in a string format,

and *returns*:
- a string with its decimal representation.
"""

# ╔═╡ e0cd9388-9c87-4cac-9704-b002cafe0dcb
function binary_to_decimal(binary::String)
    if startswith(binary, "-")
        sign = -1
        binary = binary[2:end]
    else
        sign = 1
    end
    integer_part, fractional_part = split(binary, ".", limit=2)
    decimal = 0 #initialization of decimal number
    # Convert integer part
    for i = length(integer_part):-1:1
        bit = parse(Int, integer_part[i])
        decimal += bit * 2^(length(integer_part)-i)
    end
    # Convert fractional part
    for i = 1:length(fractional_part)
        bit = parse(Int, fractional_part[i])
        decimal += bit * 2.0^(-i)  # Convert to float before raising to negative exponent
    end

    return sign * decimal
end

# ╔═╡ 2697e5b2-aef6-4e81-aa60-6b772a693a46
md"""
### Function fill\_fractional\_part(fractional\_string, digit\_accur, filling\_number)

The function below takes as *inputs*
- A fractional part of a binary number in a string format,
- A number which indicates result's length, $digit\_accur$,
- A number $(0$ or $1)$ to fill the inputed fractional part with, till it reaches length of $digit\_accur$

and *returns* 
- the $fractional\_string$, filled with $filling\_number$ as many times as it's needed in order to reach length of $digit\_accur$.
"""

# ╔═╡ dd27db70-44d6-47f6-b0a6-31aea02208cd
function fill_fractional_part(fractional_string, digit_accur::Int64, filling_number::Int64)
    if length(fractional_string) < digit_accur
        diff = digit_accur - length(fractional_string)
        for i in 1:diff
            fractional_string *= string(filling_number) #fill with zeroeeees
        end
    end
    return fractional_string
end


# ╔═╡ 10840746-5090-4bb1-97ae-46eccec16925
function splitnum(binary_string::String)
    if '.'  ∉ binary_string #integer
        binary_string = binary_string * ".0"
    end
    dotindex = findfirst('.', binary_string)
    integer_part = binary_string[1:dotindex-1] 
    fractional_part = binary_string[dotindex+1:end] 
    return(integer_part,fractional_part)
end

# ╔═╡ a2fae077-3d45-4c15-b011-8737cb3a363c
md"""
### Function produce\_one(digit\_accur)

The function below takes as *inputs*
- A number which indicates result's length, $digit\_accur$.

It *returns*
- the fractional part of the smallest binary number of length  $digit\_accur$.
"""

# ╔═╡ 90e95766-7020-4994-b41e-c507271243de
function produce_one(digit_accur::Int64)
    one = ""  #the smallest number ("the one") with 'digits' number of digits in its fractional part
    for i in 1:digit_accur-1
        one *= "0"
    end
    one *= "1" #one = 00...01 n-1 zeroes
    return(one)
end    

# ╔═╡ abd6fda3-092a-41ad-bf26-f4b121c54f57
md"""
### Function give\_next(binary\_number, digit_accur)

#### Purpose of function

We would like to give as *inputs*:

- A binary number in string format,
- An integer which indicates the maximum length of the fractional part of the binary number produced,

and get the binary number which results from the binary addition of the inputed $binary\_number$ and the smallest binary number of length $digit\_accur$.

#### How we do it

##### Initialization

1. We split the binary number in integer & fractional part (We also fill the binary number with zeroes, to make its fractional part $digit\_accur$ digits long **if needed**)
2.  We produce the smallest binary number of length $digit\_accur$.

##### Main process 

###### If binary number is negative

1. Instead of performing binary subtraction bitwise, we find the position of the digit we will borrow from
2. If there wasn't a digit to borrow, this means that the fractional part of the binary number was all zeroes. **In this case,** we get the next binary number by adding $1$ to the integer part and filling the fractional part with ones
3. **Otherwise**, there was a digit to borrow from, so we make this digit a $0$ (we subtract the smallest binary number of type: $0\ldots01$) and all the following digits equal to $1$.

###### If binary number is postive

1. We perform binary addition of $binary\_number$ and the smallest binary number of length $digit\_accur$ manually bit-by-bit. 
2. If the result it produces a carry over of $1$, that means that we need to transcend to the next integer part.
This is actually done using the helping function below (binary\_addition\_of\_one(binary\_string, one))

##### Function: binary\_addition\_of\_one(binary\_string, one)
"""

# ╔═╡ b1fef2d9-db52-43f8-af2f-cac2d7f1131f
function binary_addition_of_one(binary_string::String, one::String)
	carry_over = 0 # carry over from bitwise addition
	next_number = "" #wanted number	
    #Main process
    for i in length(binary_string):-1:1
        bitwise_sum = parse(Int64,binary_string[i]) + parse(Int64,one[i]) + carry_over
        if bitwise_sum == 1 || bitwise_sum == 0 
			next_number = string(bitwise_sum)*next_number 
            carry_over = 0
        elseif bitwise_sum ==2 
			next_number = string(0)*next_number 
            carry_over = 1
        elseif bitwise_sum ==3	
            next_number = string(1)*next_number 
            carry_over = 1
        end
    end	
    if carry_over == 1
        next_number = string(1)*next_number 
    end	  
	return(next_number::String) 
end

# ╔═╡ 5aa8cf12-b664-4097-8709-d7df5fb3ce26
md"""
##### Function: give\_next(binary\_number, digit\_accur)
"""

# ╔═╡ ebbe7ce7-324c-450e-a051-49208427760d
function give_next(binary_number::String, digit_accur::Int64)
    #Initialization 
    dotindex = findfirst('.', binary_number)
    integer_string = binary_number[1:dotindex-1] 
    fractional_string = binary_number[dotindex+1:end] 
    if length(fractional_string) < digit_accur
        fractional_string = fill_fractional_part(fractional_string, digit_accur, 0)
    end
    one = produce_one(digit_accur)
    #Main process    
    if binary_number[1] == '-' #negative binary
        digit_position_frac = digit_accur
        while  digit_position_frac > 0 && fractional_string[digit_position_frac] == '0' 
            digit_position_frac -= 1
        end    
        if digit_position_frac == 0 
            if integer_string == "-1"
                next_number = "-0."*fill_fractional_part("1",digit_accur,1)
            elseif integer_string == "-0"
                next_number = "0."*produce_one(digit_accur)
            else
                next_fractional = fill_fractional_part("1", digit_accur,1)
                next_integer = decimal_to_binary(binary_to_decimal(integer_string*".0")+1,1)
                next_number = next_integer * next_fractional
            end    
        else     
            keep_fractional = digit_position_frac - 1
            next_fractional = fill_fractional_part(fractional_string[1:keep_fractional]*"0", digit_accur,1)
            next_number =  integer_string*"."*next_fractional
        end
	else # positive binary
        next_fractional = binary_addition_of_one(fractional_string, one)
        if length(next_fractional) > digit_accur # 1000\ldots0 with digit_accur 0 ->move to next integer
			next_fractional =  fill_fractional_part("0",digit_accur,0)
			#next_integer =  binary_addition_of_one(integer_string, fill_fractional_part("0",length(integer_string)-1,0)*"1")
			next_integer = decimal_to_binary(binary_to_decimal(integer_string*".0")+1,1)
			next_number = next_integer * next_fractional
		else	
            next_number = integer_string * "." * next_fractional
        end 
    end        
   return(next_number)
end

# ╔═╡ 0d88d71e-e1ea-4352-aa84-7b3898fb66d6
md"""
### Function: fix\_truncation\_problems(fractional\_a, flag\_a, fractional\_b, flag\_b) 

The function below takes as **inputs**
	
- Two string with the fractional parts of 2 binary numbers, $fractional\_a, fractional\_b$,
- Two variables that indicate if the 2 inputed fractional representations have been truncated, $flag\_a, flag\_b$


The function returns the 2 numbers $starting, ending$ that are the bounds of our search for binary rationals $\in(a,b)$. 

In our context, its used to

- Determine if we need to start checking for binary rational numbers after <i>a</i> (if $a$ was truncated), 
Fill $a, b$ with zeroes to be able to simulate binary addition manually, as it will be described below. 
"""

# ╔═╡ 0c084311-6267-4a42-8dc7-d8d45aabc0e1
function fix_truncation_problems(a_binary, flag_a, b_binary, flag_b, digit_accur)
	if flag_a == 1 #truncated -> dealing with number < a. So I'll start from next so as to get binary rationals  ∈(a,b) .
	    starting = give_next(a_binary, digit_accur)
	else # a not truncated
		a_binary_int, a_binary_fract = split(string(a_binary), ".", limit=2)
        starting = a_binary_int*"."*fill_fractional_part(a_binary_fract, digit_accur, 0)
    end
	if  flag_b == 1 #b  truncated -> We are OK with that!
		ending = b_binary
	else #b not truncated
		b_binary_int, b_binary_fract = split(string(b_binary), ".", limit=2)
		ending = b_binary_int*"."*fill_fractional_part(b_binary_fract, digit_accur, 0)
    end
	return(starting, ending)
end	

# ╔═╡ ff0e1da1-ba0c-4991-a271-d184429bb104
md"""
----
"""

# ╔═╡ 5d1c7334-b164-4eed-a411-51e103ddde73
ShowRest(text="Show More 🤠") = @htl("""
<span>
<button  style="font-size:16px;
width:150px;
	padding:10px; 
	text-align: center;
	border-radius:10px;
	background-color:rgb(6,41,88);;
	color:white;
  	border:none;
	margin: 0 35% ;
"

>$(text)</button>

<script>

	// Select elements relative to `currentScript`
	const span = currentScript.parentElement
	const button = span.querySelector("button")

	// we wrapped the button in a `span` to hide its default behaviour from Pluto

	let show_rest = false

	button.addEventListener("click", (e) => {
		if (show_rest === true) {
    		show_rest = false;
  		} else {
    		show_rest = true;
  		}

		// we dispatch the input event on the span, not the button, because 
		// Pluto's `@bind` mechanism listens for events on the **first element** in the
		// HTML output. In our case, that's the span.

		span.value = show_rest
		span.dispatchEvent(new CustomEvent("input"))
		e.preventDefault()
	})

	// Set the initial value
	span.value = show_rest

</script>
</span>
""")

# ╔═╡ 14b5b3c2-983d-4b58-97ce-901d82537b08
ShowMe(text="Show Me!!! 🤠") = @htl("""
<span>
<button  style="font-size:16px;
width:150px;
	padding:10px; 
	text-align: center;
	border-radius:10px;
	background-color:rgb(6,41,88);;
	color:white;
  	border:none;
	margin: 0 35% ;
"

>$(text)</button>

<script>

	// Select elements relative to `currentScript`
	const span = currentScript.parentElement
	const button = span.querySelector("button")

	// we wrapped the button in a `span` to hide its default behaviour from Pluto

	let count = 1

	button.addEventListener("click", (e) => {
		count += 1

		// we dispatch the input event on the span, not the button, because 
		// Pluto's `@bind` mechanism listens for events on the **first element** in the
		// HTML output. In our case, that's the span.

		span.value = count
		span.dispatchEvent(new CustomEvent("input"))
		e.preventDefault()
	})

	// Set the initial value
	span.value = count

</script>
</span>
""")

# ╔═╡ d0b4d1d2-4e33-4aab-8ca2-f4892a6c8690
ShowAscending(text="Show 50 More (ascending) 📈") = @htl("""
<span>
<button  style="font-size:16px;
width:300px;
	padding:15px; 
	text-align: center;
	border-radius:15px;
	background-color:rgb(6,41,88);;
	color:white;
  	border:none;
	margin: 0 30% ;
"

>$(text)</button>

<script>

	// Select elements relative to `currentScript`
	const span = currentScript.parentElement
	const button = span.querySelector("button")

	// we wrapped the button in a `span` to hide its default behaviour from Pluto

	let count = 1

	button.addEventListener("click", (e) => {
		count += 1

		// we dispatch the input event on the span, not the button, because 
		// Pluto's `@bind` mechanism listens for events on the **first element** in the
		// HTML output. In our case, that's the span.

		span.value = count
		span.dispatchEvent(new CustomEvent("input"))
		e.preventDefault()
	})

	// Set the initial value
	span.value = count

</script>
</span>
""")

# ╔═╡ c8a531cd-7248-4e79-9c09-2734bfc69289
ShowDescending(text="Show 50 More (descending)📉 ") = @htl("""
<span>
<button  style="font-size:16px;
width:300px;
	padding:15px; 
	text-align: center;
	border-radius:15px;
	background-color:rgb(6,41,88);;
	color:white;
  	border:none;
	margin: 0 30% ;
"

>$(text)</button>

<script>

	// Select elements relative to `currentScript`
	const span = currentScript.parentElement
	const button = span.querySelector("button")

	// we wrapped the button in a `span` to hide its default behaviour from Pluto

	let count = 1

	button.addEventListener("click", (e) => {
		count += 1

		// we dispatch the input event on the span, not the button, because 
		// Pluto's `@bind` mechanism listens for events on the **first element** in the
		// HTML output. In our case, that's the span.

		span.value = count
		span.dispatchEvent(new CustomEvent("input"))
		e.preventDefault()
	})

	// Set the initial value
	span.value = count

</script>
</span>
""")

# ╔═╡ 831ed6f7-72ab-4c1e-be32-0a1984beadb6
macro seeprints(expr)
	quote
		stdout_bk = stdout
		rd, wr = redirect_stdout()
		$expr
		redirect_stdout(stdout_bk)
		close(wr)
		read(rd, String) |> Text
	end
end


# ╔═╡ 858d4abe-71d0-4763-961c-c5ff7b140bb6
md"""
---
"""

# ╔═╡ 833d16cc-671f-4452-8166-713b8c9c6d5e
md"""
## Action 🎬
"""

# ╔═╡ 26c7fdf1-f44b-4763-b9eb-86dba0419555
Show(MIME"text/html"(),"""<p style="font-size:16.0pt">
		Pick the first🥇 number:
		</p>""")

# ╔═╡ a8af606d-0703-4eba-882e-105a20c0d3dd
@bind first_number html"""<input value="0.25" "type="number" min="0" max="1" step="0.01"  style="border: none;
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

# ╔═╡ 3252cf7e-d76f-4c24-ab4c-25e1f456e091
Show(MIME"text/html"(),"""<p style="font-size:16.0pt">
		Now pick the second🥈 number:
		</p>""")

# ╔═╡ b991d245-cad0-49a0-806b-d2c84337ad47
@bind second_number html"""<input value="0.45" "type="number" min="0" max="1" step="0.01"  style="border: none;
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

# ╔═╡ bd4507f6-e42f-4f66-8d8e-d046d9e62ca9
begin #we want a<b
	if (parse(Float64, first_number) > parse(Float64, second_number) )
		b_decimal = parse(Float64, first_number);
		a_decimal = parse(Float64, second_number);
	else	
		a_decimal = parse(Float64, first_number);
		b_decimal = parse(Float64, second_number);
		
	end	
	Show(MIME"text/html"(),"""<p style="font-size:18.0pt">
		Let the 🪄 name 'a' the smaller of the two and 'b' the bigger number!
		</p>""")
end

# ╔═╡ 4ff0ee4f-8dcd-4d54-8ab2-f96d55051ca1
Show(MIME"text/html"(),"""<p style="font-size:15.0pt">
		<i>Select below the maximum length of the fractional part of the binary rationals we are searching for (less than 24), using the slider below:</i>
		</p>""")

# ╔═╡ c7c1d5dc-f3db-4697-81e1-e8132f498cde
@bind digit_accur Slider(3:16, 8, true)

# ╔═╡ 0a5a1032-529e-4489-adfb-788137ff39e8
begin
	a_decimal_int, a_decimal_fract = split(string(a_decimal), ".", limit=2)
	a_binary_fract, flag_a = fractional_conversion(parse(Float64, "0." * a_decimal_fract), digit_accur, true)
	a_binary = decimal_to_binary(a_decimal, digit_accur)
###### Number a	
	if flag_a == 1		
		Show(MIME"text/html"(),"""<ul> 
		<li style="font-size:16.0pt"> 
			Binary representation of a=$a_decimal: $a_binary (<span style="color:red;">truncated</span>)
		</li>
		</ul>""")
	else
		Show(MIME"text/html"(),"""
		<ul> 
		<li style="font-size:16.0pt"> 
		Binary representation of a=$a_decimal: $a_binary (<span style="color:green;">not truncated</span>)
		</li></ul>""")
		
	end
end

# ╔═╡ 1fb39575-fe39-46ec-ba0c-5d1179945507
begin
	b_decimal_int, b_decimal_fract = split(string(b_decimal), ".", limit=2)
	b_binary_fract, flag_b = fractional_conversion(parse(Float64, "0." * b_decimal_fract), digit_accur, true)
	b_binary = decimal_to_binary(b_decimal, digit_accur)
###### Number a	
	if flag_b == 1		
		Show(MIME"text/html"(),"""<ul> 
		<li style="font-size:16.0pt"> 
			Binary representation of a=$b_decimal: $b_binary (<span style="color:red;">truncated</span>)
		</li>
		</ul>""")
	else
		Show(MIME"text/html"(),"""
		<ul> 
		<li style="font-size:16.0pt"> 
		Binary representation of b=$b_decimal: $b_binary (<span style="color:green;">not truncated</span>)
		</li></ul>""")
		
	end
end

# ╔═╡ 27846cb2-f1ec-4483-b9d2-012ad6f189dd
Show(MIME"text/html"(),"""<p style="font-size:18.0pt">
		💡 <i>What will happen if I move the slider of max-length to the 👉👉?</i>
		</p>""")


# ╔═╡ 72027d0c-80c7-4f95-9a32-2cbd82a01703
begin
starting_binary, ending_binary = fix_truncation_problems(a_binary, flag_a, b_binary, flag_b, digit_accur)
starting_decimal = binary_to_decimal(starting_binary)
ending_decimal = binary_to_decimal(ending_binary)
		Show(MIME"text/html"(),"""
		<h6 style="font-size:16.0pt">So the starting and the ending numbers are: </h6> <br>
		<p  style="font-size:14.0pt">
		Starting number in </i>decimal</i> $starting_decimal  (a<sub>(10)</sub>=$a_decimal)  <br>
		Starting number in </i>binary</i> : $starting_binary   (a<sub>(2)</sub>= $a_binary) <br>
		Ending number in </i>decimal</i>  : $ending_decimal    (b<sub>(10)</sub>=$b_decimal)  <br>
		Ending number in </i>binary</i>   : $ending_binary (b<sub>(2)</sub>= $b_binary ) 
		</p>""")
end

# ╔═╡ 08f86a60-c38c-4d63-ae66-f95b23e14eea
md"""
### Let's find binary rationals and count 'em😋
"""

# ╔═╡ a062a5e1-9803-4e1f-9dd3-386d07f73478
function find_binary_rationals_and_time_passed(starting_binary, ending_binary, digit_accur)
    rationals_matrix = [] # Initialization
    upper_limit = give_next(ending_binary, digit_accur) # We don't allow numbers > b
    
    # Measure the time taken using the @elapsed macro
    time_taken = @elapsed begin
        while starting_binary != upper_limit
            starting_decimal = binary_to_decimal(string(starting_binary))
            push!(rationals_matrix, [starting_binary, starting_decimal])
            starting_binary = give_next(starting_binary, digit_accur)
        end
    end
    
    # Return the rationals_matrix and the time_taken
    return rationals_matrix, time_taken
end

# ╔═╡ 4311dd62-95cf-4855-8789-3ea045ee729a
begin
	rationals_matrix, time_elapsed = find_binary_rationals_and_time_passed(starting_binary, ending_binary, digit_accur)
	#Main process
	counter = length(rationals_matrix) # how many binary rationals did we find?
	start = counter > 100 ? 100 : counter
	if counter == 0 
		Show(MIME"text/html"(),"""<p style="font-size:14.0pt">There were <u>no</u> binary rationals ∈($a, $b) with at most $digit_accur digits on their binary fractional part.</p>""")
	elseif counter == 1	
 	Show(MIME"text/html"(),"""<p style="font-size:14.0pt">There was only 1 binary rational ∈[$a_decimal,$b_decimal] with at most $digit_accur digits in its fractional part. <br> Do you want to see it? </hp>""")
    else	
		Show(MIME"text/html"(),"""<p style="font-size:14.0pt">There were <span style="font-size:25px; font-weight:500;">$counter</span> binary rational ∈[$a_decimal,$b_decimal] with at most $digit_accur digits in their fractional part. <br>The process took <span style="font-size:23px; font-weight:500;">$time_elapsed</span> seconds <br>
		</p>""")
	end
	
end

# ╔═╡ 31de82c7-b9e1-4752-9e6a-b68eb46cb768
@bind num_clicks ShowMe()

# ╔═╡ 8430061d-9090-48e1-bd90-964cdb0c1844
begin
	mod50 = Int(floor(counter/50))
	if mod(num_clicks,2) == 1
		if counter < 50 
			@seeprints for j=1:counter
			if j==1
				println(repeat(" ", floor(Int,digit_accur/2)-1), "Binary", repeat(" ", floor(Int,digit_accur)),    "Decimal \n ")
			end	
			println( rationals_matrix[j][1], " ---> ", rationals_matrix[j][2])
			end	
		else		
			@seeprints for j=1:50
			println(rationals_matrix[j][1], " ---> ", rationals_matrix[j][2])
			end	
		end
	end	
end	

# ╔═╡ 277ec92b-1cd7-42ae-b27f-44133f3d2d87
if mod(num_clicks,2)==1 && counter > 50 
	@bind show_ascending ShowAscending()
end	

# ╔═╡ 830e259c-170a-4404-a2b5-d071f8172560
begin
	if counter > 50 && mod(num_clicks,2) == 1 
		if show_ascending >= mod50
			@seeprints for j=mod50*50+1:counter
			println(rationals_matrix[j][1], " ---> ", rationals_matrix[j][2])
			end	
		else
			@seeprints for j=50*show_ascending+1:50*(show_ascending+1)-1
			println(rationals_matrix[j][1], " ---> ", rationals_matrix[j][2])
			end	
		end
	end
end	

# ╔═╡ 3dddb160-f7c2-4b0d-843a-a7ba28161b38
if mod(num_clicks,2)==1 && counter > 50 
	@bind show_descending ShowDescending()
end	

# ╔═╡ 8b991aeb-66e3-4473-b7de-3434b070290d
begin
	
	if counter > 50 && mod(num_clicks,2) == 1
		if show_descending >= mod50
			@seeprints for j=start:-1:1
			println(rationals_matrix[j][1], " ---> ", rationals_matrix[j][2])
			end	
		else
			@seeprints for j=counter-50*(show_descending-1) :-1: counter-50*show_descending+1#(50*show_descending + 1)
			println(rationals_matrix[j][1], " ---> ", rationals_matrix[j][2])
			end	
		end
	end
end	



# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CalculusWithJulia = "a2e0e22d-7d4c-5312-9169-8b992201a882"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
CalculusWithJulia = "~0.1.2"
HypertextLiteral = "~0.9.4"
PlutoUI = "~0.7.52"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.2"
manifest_format = "2.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "91bd53c39b9cbfb5ef4b015e8b582d344532bd0a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.0"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.CalculusWithJulia]]
deps = ["Base64", "Contour", "ForwardDiff", "HCubature", "IntervalSets", "JSON", "LinearAlgebra", "PlotUtils", "Random", "RecipesBase", "Reexport", "Requires", "Roots", "SpecialFunctions", "SplitApplyCombine", "Test"]
git-tree-sha1 = "049194aa15becc95f65f2cf38ec0a221e486d1c3"
uuid = "a2e0e22d-7d4c-5312-9169-8b992201a882"
version = "0.1.2"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "e30f2f4e20f7f186dc36529910beaedc60cfa644"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.16.0"

[[deps.ChangesOfVariables]]
deps = ["InverseFunctions", "LinearAlgebra", "Test"]
git-tree-sha1 = "2fba81a302a7be671aefe194f0525ef231104e7f"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.8"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "be6ab11021cd29f0344d5c4357b163af05a48cba"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.21.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "600cc5508d66b78aae350f7accdb58763ac18589"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.10"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "fc08e5930ee9a4e03f84bfb5211cb54e7769758a"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.10"

[[deps.Combinatorics]]
git-tree-sha1 = "08c8b6831dc00bfea825826be0bc8336fc369860"
uuid = "861a8166-3701-5b0c-9a16-15d98fcdc6aa"
version = "1.0.2"

[[deps.CommonSolve]]
git-tree-sha1 = "0eee5eb66b1cf62cd6ad1b460238e60e4b09400c"
uuid = "38540f10-b2f7-11e9-35d8-d573e4eb0ff2"
version = "0.2.4"

[[deps.CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

[[deps.Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "4e88377ae7ebeaf29a047aa1ee40826e0b708a5d"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.7.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "fe2838a593b5f776e1597e086dcd47560d94e816"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.5.3"

[[deps.Contour]]
git-tree-sha1 = "d05d9e7b7aedff4e5b51a029dced05cfb6125781"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.2"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "cf25ccb972fec4e4817764d01c82386ae94f77b4"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.14"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Dictionaries]]
deps = ["Indexing", "Random", "Serialization"]
git-tree-sha1 = "e82c3c97b5b4ec111f3c1b55228cebc7510525a2"
uuid = "85a47980-9c8c-11e8-2b9f-f7ca1fa99fb4"
version = "0.3.25"

[[deps.DiffResults]]
deps = ["StaticArraysCore"]
git-tree-sha1 = "782dd5f4561f5d267313f23853baaaa4c52ea621"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.1.0"

[[deps.DiffRules]]
deps = ["IrrationalConstants", "LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "23163d55f885173722d1e4cf0f6110cdbaf7e272"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.15.1"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "LogExpFunctions", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions", "StaticArrays"]
git-tree-sha1 = "00e252f4d706b3d55a8863432e742bf5717b498d"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.35"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.HCubature]]
deps = ["Combinatorics", "DataStructures", "LinearAlgebra", "QuadGK", "StaticArrays"]
git-tree-sha1 = "e95b36755023def6ebc3d269e6483efa8b2f7f65"
uuid = "19dc6840-f33b-545b-b366-655c7e3ffd49"
version = "1.5.1"

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

[[deps.Indexing]]
git-tree-sha1 = "ce1566720fd6b19ff3411404d4b977acd4814f9f"
uuid = "313cdc1a-70c2-5d6a-ae34-0150d3930a38"
version = "1.1.1"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.IntervalSets]]
deps = ["Dates", "Random", "Statistics"]
git-tree-sha1 = "16c0cc91853084cb5f58a78bd209513900206ce6"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.7.4"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "eabe3125edba5c9c10b60a160b1779a000dc8b29"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.11"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

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

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "c3ce8e7420b3a6e071e0fe4745f5d4300e37b13f"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.24"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "42324d08725e200c23d4dfb549e0d5d89dede2d2"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.10"

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

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "d321bf2de576bf25ec4d3e4360faca399afca282"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.0"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "4b2e829ee66d4218e0cef22c0a64ee37cf258c29"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.7.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "PrecompileTools", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "f92e1315dadf8c46561fb9396e525f7200cdc227"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.3.5"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "e47cd150dbe0443c3a3651bc5b9cbd5576ab75b7"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.52"

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

[[deps.QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "6ec7ac8412e83d57e313393220879ede1740f9ee"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.8.2"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RecipesBase]]
deps = ["PrecompileTools"]
git-tree-sha1 = "5c3d09cc4f31f5fc6af001c250bf1278733100ff"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.4"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Roots]]
deps = ["ChainRulesCore", "CommonSolve", "Printf", "Setfield"]
git-tree-sha1 = "de432823e8aab4dd1a985be4be768f95acf152d4"
uuid = "f2b01f46-fcfa-551c-844a-d8ac1e96c665"
version = "2.0.17"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "StaticArraysCore"]
git-tree-sha1 = "e2cc6d8c88613c05e1defb55170bf5ff211fbeac"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "1.1.1"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "7beb031cf8145577fbccacd94b8a8f4ce78428d3"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.3.0"

[[deps.SplitApplyCombine]]
deps = ["Dictionaries", "Indexing"]
git-tree-sha1 = "48f393b0231516850e39f6c756970e7ca8b77045"
uuid = "03a91e81-4c3e-53e1-a0a4-9c0c8f19dd66"
version = "1.2.2"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "StaticArraysCore", "Statistics"]
git-tree-sha1 = "fffc14c695c17bfdbfa92a2a01836cdc542a1e46"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.6.1"

[[deps.StaticArraysCore]]
git-tree-sha1 = "36b3d696ce6366023a0ea192b4cd442268995a0d"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.2"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

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
# ╠═a9153295-77fc-4a37-95e0-a3585671f54d
# ╠═34151786-af3d-4973-8d37-a324a60b6a83
# ╟─b49f4090-0052-4526-a73b-b754e454ec51
# ╟─a0b35787-5bdd-4038-9871-820a72521386
# ╟─a7444b47-7922-46af-b071-e9e23a20d055
# ╟─8fc457b5-4878-4326-8b73-3ed54a84d49b
# ╟─0a5cdbb7-32c1-42d6-997a-4c47fc857f6e
# ╟─9771cb0d-8722-4fcd-a577-9b167997bad6
# ╠═4c7eabef-886f-4ac0-8b19-7b9bc0632d72
# ╟─df6ae140-cb67-4a5e-b2f4-a47987d58597
# ╠═799cb94f-fae8-48e5-aab5-b231748511a5
# ╟─19d9085b-0c90-405b-ac12-a3e3c5a0b654
# ╠═7ec2d89b-316e-4057-8070-283bd38be577
# ╟─4935107a-bebb-4404-b364-16165ad9a832
# ╠═e0cd9388-9c87-4cac-9704-b002cafe0dcb
# ╟─2697e5b2-aef6-4e81-aa60-6b772a693a46
# ╠═dd27db70-44d6-47f6-b0a6-31aea02208cd
# ╠═10840746-5090-4bb1-97ae-46eccec16925
# ╟─a2fae077-3d45-4c15-b011-8737cb3a363c
# ╠═90e95766-7020-4994-b41e-c507271243de
# ╟─abd6fda3-092a-41ad-bf26-f4b121c54f57
# ╠═b1fef2d9-db52-43f8-af2f-cac2d7f1131f
# ╟─5aa8cf12-b664-4097-8709-d7df5fb3ce26
# ╠═ebbe7ce7-324c-450e-a051-49208427760d
# ╟─0d88d71e-e1ea-4352-aa84-7b3898fb66d6
# ╠═0c084311-6267-4a42-8dc7-d8d45aabc0e1
# ╟─ff0e1da1-ba0c-4991-a271-d184429bb104
# ╟─5d1c7334-b164-4eed-a411-51e103ddde73
# ╟─14b5b3c2-983d-4b58-97ce-901d82537b08
# ╟─d0b4d1d2-4e33-4aab-8ca2-f4892a6c8690
# ╟─c8a531cd-7248-4e79-9c09-2734bfc69289
# ╟─831ed6f7-72ab-4c1e-be32-0a1984beadb6
# ╟─858d4abe-71d0-4763-961c-c5ff7b140bb6
# ╟─833d16cc-671f-4452-8166-713b8c9c6d5e
# ╟─26c7fdf1-f44b-4763-b9eb-86dba0419555
# ╟─a8af606d-0703-4eba-882e-105a20c0d3dd
# ╟─3252cf7e-d76f-4c24-ab4c-25e1f456e091
# ╟─b991d245-cad0-49a0-806b-d2c84337ad47
# ╟─bd4507f6-e42f-4f66-8d8e-d046d9e62ca9
# ╟─0a5a1032-529e-4489-adfb-788137ff39e8
# ╟─1fb39575-fe39-46ec-ba0c-5d1179945507
# ╟─4ff0ee4f-8dcd-4d54-8ab2-f96d55051ca1
# ╟─c7c1d5dc-f3db-4697-81e1-e8132f498cde
# ╟─27846cb2-f1ec-4483-b9d2-012ad6f189dd
# ╟─72027d0c-80c7-4f95-9a32-2cbd82a01703
# ╟─08f86a60-c38c-4d63-ae66-f95b23e14eea
# ╟─a062a5e1-9803-4e1f-9dd3-386d07f73478
# ╟─4311dd62-95cf-4855-8789-3ea045ee729a
# ╟─31de82c7-b9e1-4752-9e6a-b68eb46cb768
# ╟─8430061d-9090-48e1-bd90-964cdb0c1844
# ╟─277ec92b-1cd7-42ae-b27f-44133f3d2d87
# ╟─830e259c-170a-4404-a2b5-d071f8172560
# ╟─3dddb160-f7c2-4b0d-843a-a7ba28161b38
# ╟─8b991aeb-66e3-4473-b7de-3434b070290d
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
