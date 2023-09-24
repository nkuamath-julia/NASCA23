### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# ╔═╡ 8fb67fb0-1414-47df-acae-7ffa1d131ce4
md"The following code can be used to find possible pivot patterns of Hadamard matrices of order 20. It should be noted that, in order to avoid rounding errors, the use of rational numbers was chosen for any operation whose result is significant and not necessarily an integer."

# ╔═╡ 870ea327-7a76-4fc8-8c92-a4df03ef9388
md"We need the following functions:"

# ╔═╡ 42f35a58-98cb-4a25-ab1d-21e144c45881
md"The first two functions we need can be used to generate Hadamard matrices that are equivalent to given ones."

# ╔═╡ 4540be78-9a6d-4832-b171-e68034a74228
md"The first one, ```ti_generator```, generates and returns the necessary information to do so for matrices of a given order."

# ╔═╡ 743ce82f-d94c-43bc-8b91-19bbcc93c70e
function ti_generator(n)
	#Total number of operations (between 100 and 200)
	n_0 = rand(100:200);
	#Type of operation: 1: Line swap, 2: Column swap, 3: Negation of line, 4: Negation of column
	operations = rand(1:4, n_0);
	#Number of times each operation is to be performed
	n_1 = count(==(1), operations);
	n_2 = count(==(2), operations);
	n_3 = count(==(3), operations);
	n_4 = count(==(4), operations);
	#Indices of rows that are to be swapped
	rs = zeros(Int, 2, n_1);
	#Select the first row for each swap
	rs[1, :] = rand(1:n, n_1);
	#Select the second row for each swap
	for i = 1:n_1
		rs[2, i] = rand([1:rs[1, i]-1; rs[1, i]+1:n]);
	end
	#Indices of columns that are to be swapped
	cs = zeros(Int, 2, n_2);
	#Select the first column for each swap
	cs[1, :] = rand(1:n, n_2);
	#Select the second column for each swap
	for i = 1:n_2
		cs[2, i] = rand([1:cs[1, i]-1; cs[1, i]+1:n]);
	end
	#Indices of rows that are to be negated
	rn = rand(1:n, n_3);
	#Indices of columns that are to be negated
	cn = rand(1:n, n_4);
	return operations, rs, cs, rn, cn;
end

# ╔═╡ 69f45afe-a66b-4427-b911-a2eef1b6f9e3
md"The second one, ```transform```, takes as input a matrix and an instance of such information (where, of course, the order of the matrix should match the order the information was generated for) and outputs a new matrix that is the result of performing the described operations on the given matrix."

# ╔═╡ 1bcacd18-7ed7-4113-9501-22ef800334be
function transform(A, ti)
	A = copy(A);
	n = size(A, 1);
	n_1 = 0;
	n_2 = 0;
	n_3 = 0;
	n_4 = 0;
	operations, rs, cs, rn, cn = ti;
	for i = operations
		if i == 1
			n_1 += 1;
			A[[rs[1, n_1] rs[2, n_1]], :] = A[[rs[2, n_1] rs[1, n_1]], :];
		elseif i == 2
			n_2 += 1;
			A[:, [cs[1, n_2] cs[2, n_2]]] = A[:, [cs[2, n_2] cs[1, n_2]]];
		elseif i == 3
			n_3 += 1;
			A[rn[n_3], :] *= -1;
		elseif i == 4
			n_4 += 1;
			A[:, cn[n_4]] *= -1;
		end
	end
	return A;
end

# ╔═╡ 38d0378b-9703-4b0c-8c48-628f72082889
md"The next function we need is ```find_pivots```, which essentially performs Gaussian elimination with complete pivoting (GECP) on its input and returns its pivots."

# ╔═╡ ce66e4fa-3255-4667-ba24-3f04b740a43d
function find_pivots(A)
	A = copy(A);
	n = size(A, 1);
	pivots = zeros(Rational, 1, n);
	for k = 1:n-1
		#Find pivot
		r_k = k;
		c_k = k;
		for i = k:n
			for j = k:n
				if abs(A[i, j]) > abs(A[r_k, c_k])
					r_k = i;
					c_k = j;
				end
			end
		end
		if A[r_k, c_k] == 0
			return "Error!";
		end
		pivots[k] = abs(A[r_k, c_k]);
		#Swap the appropriate lines and columns to get the pivot to the correct position
		A[[k r_k], k:n] = A[[r_k k], k:n];
		A[k:n, [k c_k]] = A[k:n, [c_k k]];
		#Calculate and store the multipliers
		A[k+1:n, k] //= A[k, k];
		#Update the matrix
		A[k+1:n, k+1:n] -= A[k+1:n, k:k]*A[k:k, k+1:n];
	end
	pivots[n] = abs(A[n, n]);
	return pivots;
end

# ╔═╡ 6ab2c57a-8a22-4103-8080-59785a71f426
md"The last (and main) function we need to find pivot patterns is ```find_pivot_patterns```, which uses the previous ones in order to find and store new pivot patterns, along with the information required to reconstruct the first matrix found that gave rise to each pivot pattern. Specifically, it stores the index (in the vector ```r``` of the chosen representatives) of the matrix that was transformed, as well the transformation information used. It also stores the number of matrices that have been documented to give rise to each pivot pattern, for statistical purposes."

# ╔═╡ effb4cdf-c2ac-4475-8376-fb5ac90d50d7
function find_pivot_patterns(r, mi_fn, pp_fn, c_fn)
	lines = readlines(pp_fn);
	m = length(lines);
	n = count(" ", lines[1])+1;
	M = zeros(Rational, m, n);
	for i = 1:m
		M[i, :] = eval(Meta.parse(lines[i]));
    end
	counts_string = readline(c_fn)[2:end-1];
	counts = [parse(Int, i) for i = split(counts_string, ", ")];
	number_of_matrices = sum(counts);
	#Print the results so far (from the initial representatives of each equivalence class and the previous times the function may have been run)
	print("Pivot patterns: ", m, "\nMatrices: ", number_of_matrices, "\n\n");
	while true
		ti = ti_generator(n);
		for i = 1:length(r)
			number_of_matrices += 1;
			pivots = find_pivots(transform(r[i], ti));
			new = true;
			#If this pivot pattern is not new, increase the number of matrices from which it has emerged by 1
			for j = 1:m
				if M[j, :]' == pivots
					new = false;
					counts[j] += 1;
					#Store the results so far (with limited frequency, for efficiency)
					if number_of_matrices%100000 == 0
						open(c_fn, "w") do f
							write(f, string(counts));
						end
						print("Pivot patterns: ", m, "\nMatrices: ", number_of_matrices, "\nSleeping for 5 seconds, in case program termination is desired.\n");
						sleep(5);
						print("Continuing.\n\n");
					end
					break;
				end
			end
			#If it is new, update the necessary information within the code, store the appropriate information and print the results so far
			if new
				m += 1;
				M_temp = M;
				M = zeros(Rational, m, n);
				M[1:m-1, :] = M_temp;
				M[m, :] = pivots;
				push!(counts, 1);
				pivots_string = string(pivots)[9:end];
				open(mi_fn, "a") do f
					write(f, string("\n", i, ", ", ti));
				end
				open(pp_fn, "a") do f
					write(f, "\n", pivots_string);
				end
				open(c_fn, "w") do f
					write(f, string(counts));
				end
				print("New pivot pattern found: ", pivots_string, "\nPivot patterns: ", m, "\nMatrices: ", number_of_matrices, "\n\n");
			end
		end
	end
end

# ╔═╡ aec29195-277f-4bd2-b161-f13ddba59ff8
md"Since we already have some Hadamard matrices available, it makes sense to find their pivot patterns and store the relevant information before doing so for others that are created by transforming them. This can be done manually, before running the above function."

# ╔═╡ d239ba8e-da2a-49e8-9692-8adaf5701d2a
md"After we have found some pivot patterns, we can use the following function to store all known values that can appear for each pivot, based on the information stored in a given file of pivot patterns."

# ╔═╡ 482bc831-c509-4b05-b9c7-57bbc7a67e2e
function find_possible_pivot_values(pp_fn, ppv_fn)
	lines = readlines(pp_fn);
	m = length(lines);
	n = count(" ", lines[1])+1;
	M = zeros(Rational, m, n);
	for i = 1:m
		M[i, :] = eval(Meta.parse(lines[i]));
    end
	for j = 1:n
		values = [];
		for i = 1:m
			if !(M[i, j] in values)
				push!(values, M[i, j]);
			end
		end
		open(ppv_fn, "a") do f
			write(f, string(j, ": ", string(values)[4:end]));
			if j != n
				write(f, "\n");
			end
		end
	end
end

# ╔═╡ 460067cb-e2ad-49fd-bb21-3e4f8fac2b47
md"It is known that exactly 3 equivalence classes of Hadamard matrices of order 20 exist. The following matrices, which are used to generate equivalent ones, are representatives of these classes, one for each class:"

# ╔═╡ e638b059-0fcd-46c1-b39e-6d41b60886b2
H1 = Rational[1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1; 1 1 -1 1 1 -1 -1 -1 -1 1 -1 1 -1 1 1 1 1 -1 -1 1; 1 1 1 -1 1 1 -1 -1 -1 -1 1 -1 1 -1 1 1 1 1 -1 -1; 1 -1 1 1 -1 1 1 -1 -1 -1 -1 1 -1 1 -1 1 1 1 1 -1; 1 -1 -1 1 1 -1 1 1 -1 -1 -1 -1 1 -1 1 -1 1 1 1 1; 1 1 -1 -1 1 1 -1 1 1 -1 -1 -1 -1 1 -1 1 -1 1 1 1; 1 1 1 -1 -1 1 1 -1 1 1 -1 -1 -1 -1 1 -1 1 -1 1 1; 1 1 1 1 -1 -1 1 1 -1 1 1 -1 -1 -1 -1 1 -1 1 -1 1; 1 1 1 1 1 -1 -1 1 1 -1 1 1 -1 -1 -1 -1 1 -1 1 -1; 1 -1 1 1 1 1 -1 -1 1 1 -1 1 1 -1 -1 -1 -1 1 -1 1; 1 1 -1 1 1 1 1 -1 -1 1 1 -1 1 1 -1 -1 -1 -1 1 -1; 1 -1 1 -1 1 1 1 1 -1 -1 1 1 -1 1 1 -1 -1 -1 -1 1; 1 1 -1 1 -1 1 1 1 1 -1 -1 1 1 -1 1 1 -1 -1 -1 -1; 1 -1 1 -1 1 -1 1 1 1 1 -1 -1 1 1 -1 1 1 -1 -1 -1; 1 -1 -1 1 -1 1 -1 1 1 1 1 -1 -1 1 1 -1 1 1 -1 -1; 1 -1 -1 -1 1 -1 1 -1 1 1 1 1 -1 -1 1 1 -1 1 1 -1; 1 -1 -1 -1 -1 1 -1 1 -1 1 1 1 1 -1 -1 1 1 -1 1 1; 1 1 -1 -1 -1 -1 1 -1 1 -1 1 1 1 1 -1 -1 1 1 -1 1; 1 1 1 -1 -1 -1 -1 1 -1 1 -1 1 1 1 1 -1 -1 1 1 -1; 1 -1 1 1 -1 -1 -1 -1 1 -1 1 -1 1 1 1 1 -1 -1 1 1];

# ╔═╡ b832c41b-ae9b-49be-9cc2-3d7f92dc45fb
H2 = Rational[1 -1 -1 -1 -1 1 -1 -1 -1 -1 1 1 -1 -1 1 1 -1 1 1 -1; -1 1 -1 -1 -1 -1 1 -1 -1 -1 1 1 1 -1 -1 -1 1 -1 1 1; -1 -1 1 -1 -1 -1 -1 1 -1 -1 -1 1 1 1 -1 1 -1 1 -1 1; -1 -1 -1 1 -1 -1 -1 -1 1 -1 -1 -1 1 1 1 1 1 -1 1 -1; -1 -1 -1 -1 1 -1 -1 -1 -1 1 1 -1 -1 1 1 -1 1 1 -1 1; -1 1 1 1 1 1 -1 -1 -1 -1 -1 1 -1 -1 1 1 1 -1 -1 1; 1 -1 1 1 1 -1 1 -1 -1 -1 1 -1 1 -1 -1 1 1 1 -1 -1; 1 1 -1 1 1 -1 -1 1 -1 -1 -1 1 -1 1 -1 -1 1 1 1 -1; 1 1 1 -1 1 -1 -1 -1 1 -1 -1 -1 1 -1 1 -1 -1 1 1 1; 1 1 1 1 -1 -1 -1 -1 -1 1 1 -1 -1 1 -1 1 -1 -1 1 1; -1 -1 1 1 -1 1 -1 1 1 -1 1 -1 -1 -1 -1 -1 1 1 1 1; -1 -1 -1 1 1 -1 1 -1 1 1 -1 1 -1 -1 -1 1 -1 1 1 1; 1 -1 -1 -1 1 1 -1 1 -1 1 -1 -1 1 -1 -1 1 1 -1 1 1; 1 1 -1 -1 -1 1 1 -1 1 -1 -1 -1 -1 1 -1 1 1 1 -1 1; -1 1 1 -1 -1 -1 1 1 -1 1 -1 -1 -1 -1 1 1 1 1 1 -1; -1 1 -1 -1 1 -1 -1 1 1 -1 1 -1 -1 -1 -1 1 -1 -1 -1 -1; 1 -1 1 -1 -1 -1 -1 -1 1 1 -1 1 -1 -1 -1 -1 1 -1 -1 -1; -1 1 -1 1 -1 1 -1 -1 -1 1 -1 -1 1 -1 -1 -1 -1 1 -1 -1; -1 -1 1 -1 1 1 1 -1 -1 -1 -1 -1 -1 1 -1 -1 -1 -1 1 -1; 1 -1 -1 1 -1 -1 1 1 -1 -1 -1 -1 -1 -1 1 -1 -1 -1 -1 1];

# ╔═╡ 93954873-6158-4da0-be2d-e3216320dc82
H3 = Rational[1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1; 1 1 1 1 1 1 1 1 1 1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1; 1 1 1 1 1 -1 -1 -1 -1 -1 1 1 1 1 1 -1 -1 -1 -1 -1; 1 1 1 1 -1 1 -1 -1 -1 -1 1 -1 -1 -1 -1 1 1 1 1 -1; 1 1 1 -1 -1 -1 1 1 -1 -1 -1 1 1 -1 -1 1 1 -1 -1 1; 1 1 -1 1 -1 -1 1 1 -1 -1 -1 -1 -1 1 1 -1 -1 1 1 1; 1 1 -1 -1 1 1 -1 -1 1 -1 -1 1 -1 1 -1 1 -1 1 -1 1; 1 1 -1 -1 1 1 -1 -1 -1 1 -1 -1 1 -1 1 -1 1 -1 1 1; 1 1 -1 -1 -1 -1 1 -1 1 1 1 1 -1 -1 1 -1 1 1 -1 -1; 1 1 -1 -1 -1 -1 -1 1 1 1 1 -1 1 1 -1 1 -1 -1 1 -1; 1 -1 1 1 -1 -1 -1 -1 1 1 -1 1 -1 -1 1 1 -1 -1 1 1; 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 -1 -1 -1 1 1 1; 1 -1 1 -1 1 -1 -1 1 -1 1 -1 1 -1 1 -1 -1 1 1 1 -1; 1 -1 1 -1 -1 1 1 -1 -1 1 -1 -1 1 1 1 1 -1 1 -1 -1; 1 -1 1 -1 -1 1 -1 1 1 -1 1 -1 -1 1 1 -1 1 -1 -1 1; 1 -1 -1 1 1 -1 1 -1 -1 1 1 -1 -1 1 -1 1 1 -1 -1 1; 1 -1 -1 1 1 -1 -1 1 1 -1 -1 -1 1 -1 1 1 1 1 -1 -1; 1 -1 -1 1 -1 1 1 -1 1 -1 -1 1 1 1 -1 -1 1 -1 1 -1; 1 -1 -1 1 -1 1 -1 1 -1 1 1 1 1 -1 -1 -1 -1 1 -1 1; 1 -1 -1 -1 1 1 1 1 -1 -1 1 1 -1 -1 1 1 -1 -1 1 -1];

# ╔═╡ Cell order:
# ╟─8fb67fb0-1414-47df-acae-7ffa1d131ce4
# ╟─870ea327-7a76-4fc8-8c92-a4df03ef9388
# ╟─42f35a58-98cb-4a25-ab1d-21e144c45881
# ╟─4540be78-9a6d-4832-b171-e68034a74228
# ╠═743ce82f-d94c-43bc-8b91-19bbcc93c70e
# ╟─69f45afe-a66b-4427-b911-a2eef1b6f9e3
# ╠═1bcacd18-7ed7-4113-9501-22ef800334be
# ╟─38d0378b-9703-4b0c-8c48-628f72082889
# ╠═ce66e4fa-3255-4667-ba24-3f04b740a43d
# ╟─6ab2c57a-8a22-4103-8080-59785a71f426
# ╠═effb4cdf-c2ac-4475-8376-fb5ac90d50d7
# ╟─aec29195-277f-4bd2-b161-f13ddba59ff8
# ╟─d239ba8e-da2a-49e8-9692-8adaf5701d2a
# ╠═482bc831-c509-4b05-b9c7-57bbc7a67e2e
# ╟─460067cb-e2ad-49fd-bb21-3e4f8fac2b47
# ╠═e638b059-0fcd-46c1-b39e-6d41b60886b2
# ╠═b832c41b-ae9b-49be-9cc2-3d7f92dc45fb
# ╠═93954873-6158-4da0-be2d-e3216320dc82
