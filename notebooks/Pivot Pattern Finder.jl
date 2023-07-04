### A Pluto.jl notebook ###
# v0.19.25

using Markdown
using InteractiveUtils

# ╔═╡ 8fb67fb0-1414-47df-acae-7ffa1d131ce4
md"The following code can be used to find possible pivot patterns of Hadamard matrices of order 20. It should be noted that, in order to avoid rounding errors, the use of rational numbers was chosen for any operation whose result is significant and not necessarily an integer."

# ╔═╡ 870ea327-7a76-4fc8-8c92-a4df03ef9388
md"We need the following functions:"

# ╔═╡ 38d0378b-9703-4b0c-8c48-628f72082889
md"The first function we need is ```find_pivots```, which essentially performs Gaussian elimination with complete pivoting (GECP) on its input and returns its pivots."

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

# ╔═╡ 42f35a58-98cb-4a25-ab1d-21e144c45881
md"The next two functions can be used to generate Hadamard matrices that are equivalent to given ones."

# ╔═╡ 4540be78-9a6d-4832-b171-e68034a74228
md"The first one, ```transformation_information_generator```, generates and returns the necessary information to do so for matrices of a given order."

# ╔═╡ 743ce82f-d94c-43bc-8b91-19bbcc93c70e
function transformation_information_generator(n)
	#Total number of operations (between 100 and 200)
	number_of_operations = rand(100:200);
	#Type of operation: 1: Line swap, 2: Column swap, 3: Negation of line, 4: Negation of column
	types_of_operations = rand(1:4, number_of_operations);
	#Number of times each operation is to be performed
	number_of_row_swaps = count(==(1), types_of_operations);
	number_of_column_swaps = count(==(2), types_of_operations);
	number_of_row_negations = count(==(3), types_of_operations);
	number_of_column_negations = count(==(4), types_of_operations);
	#Indices of lines that are to be swapped
	row_swap_indices = zeros(Int, 2, number_of_row_swaps);
	#Select the first line for each swap
	row_swap_indices[1, :] = rand(1:n, number_of_row_swaps);
	#Select the second line for each swap
	for i = 1:number_of_row_swaps
		r1 = row_swap_indices[1, i];
		rows = append!(collect(1:r1-1), r1+1:n);
		row_swap_indices[2, i] = rand(rows);
	end
	#Similarly for columns
	column_swap_indices = zeros(Int, 2, number_of_column_swaps);
	column_swap_indices[1, :] = rand(1:n, number_of_column_swaps);
	for i = 1:number_of_column_swaps
		c1 = column_swap_indices[1, i];
		columns = append!(collect(1:c1-1), c1+1:n);
		column_swap_indices[2, i] = rand(columns);
	end
	#Indices of lines and columns that are to be negated
	row_negation_indices = rand(1:n, number_of_row_negations);
	column_negation_indices = rand(1:n, number_of_column_negations);
	return types_of_operations, row_swap_indices, column_swap_indices, row_negation_indices, column_negation_indices;
end

# ╔═╡ 69f45afe-a66b-4427-b911-a2eef1b6f9e3
md"The second one, ```transform```, takes as input a matrix and an instance of such information (where, of course, the order of the matrix should match the order the information was generated for) and outputs a new matrix that is the result of performing the described operations on the given matrix."

# ╔═╡ 1bcacd18-7ed7-4113-9501-22ef800334be
function transform(A, transformation_information)
	types_of_operations, row_swap_indices, column_swap_indices, row_negation_indices, column_negation_indices = transformation_information;
	A = copy(A);
	n = size(A, 1);
	n_rs = 0;
	n_cs = 0;
	n_ri = 0;
	n_ci = 0;
	for i = types_of_operations
		if i == 1
			n_rs += 1;
			A[[row_swap_indices[1, n_rs] row_swap_indices[2, n_rs]], :] = A[[row_swap_indices[2, n_rs] row_swap_indices[1, n_rs]], :];
		elseif i == 2
			n_cs += 1;
			A[:, [column_swap_indices[1, n_cs] column_swap_indices[2, n_cs]]] = A[:, [column_swap_indices[2, n_cs] column_swap_indices[1, n_cs]]];
		elseif i == 3
			n_ri += 1;
			A[row_negation_indices[n_ri], :] *= -1;
		elseif i == 4
			n_ci += 1;
			A[:, column_negation_indices[n_ci]] *= -1;
		end
	end
	return A;
end

# ╔═╡ 74cd7923-bed5-4612-89df-0690898eee16
md"The following function returns a matrix containing all the pivot patterns that are stored in a given text file with appropriately formatted content."

# ╔═╡ 5121c70b-512f-4904-9088-dc70aac2a101
function stored_pivot_patterns(filename)
	l = readlines(filename);
	m = length(l);
	n = count(" ", l[1])+1;
	M = zeros(Rational, m, n);
	for i = 1:m
		M[i, :] = eval(Meta.parse(l[i]));
    end
	return M;
end

# ╔═╡ 6ab2c57a-8a22-4103-8080-59785a71f426
md"The following function uses the previous ones in order to find and store new pivot patterns, along with the information required to reconstruct the first matrix found that gave rise to each pivot pattern. Specifically, it stores the index within the list ```matrices``` (which is defined later) of the matrix that was transformed, as well the transformation information used. It also stores the number of matrices that have been documented to give rise to each pivot pattern, for statistical purposes."

# ╔═╡ aec29195-277f-4bd2-b161-f13ddba59ff8
md"Since we already have some Hadamard matrices available, it makes sense to find their pivot patterns before doing so for others that are created by transforming them. The following function does this and prints the results, which can then be processed and stored manually, along with all the relevant information."

# ╔═╡ d239ba8e-da2a-49e8-9692-8adaf5701d2a
md"The following function stores all known values that can appear for each pivot, within a given file of pivot patterns."

# ╔═╡ 482bc831-c509-4b05-b9c7-57bbc7a67e2e
function find_possible_pivot_values(input_filename, output_filename)
	M = stored_pivot_patterns(input_filename);
	m, n = size(M);
	for j = 1:n
		values = [];
		for i = 1:m
			if !(M[i, j] in values)
				push!(values, M[i, j]);
			end
		end
		open(output_filename, "a") do f
			values_string = string(values)[4:end];
			write(f, string(j, ": ", values_string));
			if j != n
				write(f, "\n");
			end
		end
	end
end

# ╔═╡ 460067cb-e2ad-49fd-bb21-3e4f8fac2b47
md"It is known that exactly 3 equivalence classes of Hadamard matrices of order 20 exist. The following matrices, which are used to generate equivalent ones, are representatives of these classes, one for each class:"

# ╔═╡ e638b059-0fcd-46c1-b39e-6d41b60886b2
H1 = Rational[1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1;1 1 -1 1 1 -1 -1 -1 -1 1 -1 1 -1 1 1 1 1 -1 -1 1;1 1 1 -1 1 1 -1 -1 -1 -1 1 -1 1 -1 1 1 1 1 -1 -1;1 -1 1 1 -1 1 1 -1 -1 -1 -1 1 -1 1 -1 1 1 1 1 -1;1 -1 -1 1 1 -1 1 1 -1 -1 -1 -1 1 -1 1 -1 1 1 1 1;1 1 -1 -1 1 1 -1 1 1 -1 -1 -1 -1 1 -1 1 -1 1 1 1;1 1 1 -1 -1 1 1 -1 1 1 -1 -1 -1 -1 1 -1 1 -1 1 1;1 1 1 1 -1 -1 1 1 -1 1 1 -1 -1 -1 -1 1 -1 1 -1 1;1 1 1 1 1 -1 -1 1 1 -1 1 1 -1 -1 -1 -1 1 -1 1 -1;1 -1 1 1 1 1 -1 -1 1 1 -1 1 1 -1 -1 -1 -1 1 -1 1;1 1 -1 1 1 1 1 -1 -1 1 1 -1 1 1 -1 -1 -1 -1 1 -1;1 -1 1 -1 1 1 1 1 -1 -1 1 1 -1 1 1 -1 -1 -1 -1 1;1 1 -1 1 -1 1 1 1 1 -1 -1 1 1 -1 1 1 -1 -1 -1 -1;1 -1 1 -1 1 -1 1 1 1 1 -1 -1 1 1 -1 1 1 -1 -1 -1;1 -1 -1 1 -1 1 -1 1 1 1 1 -1 -1 1 1 -1 1 1 -1 -1;1 -1 -1 -1 1 -1 1 -1 1 1 1 1 -1 -1 1 1 -1 1 1 -1;1 -1 -1 -1 -1 1 -1 1 -1 1 1 1 1 -1 -1 1 1 -1 1 1;1 1 -1 -1 -1 -1 1 -1 1 -1 1 1 1 1 -1 -1 1 1 -1 1;1 1 1 -1 -1 -1 -1 1 -1 1 -1 1 1 1 1 -1 -1 1 1 -1;1 -1 1 1 -1 -1 -1 -1 1 -1 1 -1 1 1 1 1 -1 -1 1 1];

# ╔═╡ b832c41b-ae9b-49be-9cc2-3d7f92dc45fb
H2 = Rational[1 -1 -1 -1 -1 1 -1 -1 -1 -1 1 1 -1 -1 1 1 -1 1 1 -1;-1 1 -1 -1 -1 -1 1 -1 -1 -1 1 1 1 -1 -1 -1 1 -1 1 1;-1 -1 1 -1 -1 -1 -1 1 -1 -1 -1 1 1 1 -1 1 -1 1 -1 1;-1 -1 -1 1 -1 -1 -1 -1 1 -1 -1 -1 1 1 1 1 1 -1 1 -1;-1 -1 -1 -1 1 -1 -1 -1 -1 1 1 -1 -1 1 1 -1 1 1 -1 1;-1 1 1 1 1 1 -1 -1 -1 -1 -1 1 -1 -1 1 1 1 -1 -1 1;1 -1 1 1 1 -1 1 -1 -1 -1 1 -1 1 -1 -1 1 1 1 -1 -1;1 1 -1 1 1 -1 -1 1 -1 -1 -1 1 -1 1 -1 -1 1 1 1 -1;1 1 1 -1 1 -1 -1 -1 1 -1 -1 -1 1 -1 1 -1 -1 1 1 1;1 1 1 1 -1 -1 -1 -1 -1 1 1 -1 -1 1 -1 1 -1 -1 1 1;-1 -1 1 1 -1 1 -1 1 1 -1 1 -1 -1 -1 -1 -1 1 1 1 1;-1 -1 -1 1 1 -1 1 -1 1 1 -1 1 -1 -1 -1 1 -1 1 1 1;1 -1 -1 -1 1 1 -1 1 -1 1 -1 -1 1 -1 -1 1 1 -1 1 1;1 1 -1 -1 -1 1 1 -1 1 -1 -1 -1 -1 1 -1 1 1 1 -1 1;-1 1 1 -1 -1 -1 1 1 -1 1 -1 -1 -1 -1 1 1 1 1 1 -1;-1 1 -1 -1 1 -1 -1 1 1 -1 1 -1 -1 -1 -1 1 -1 -1 -1 -1;1 -1 1 -1 -1 -1 -1 -1 1 1 -1 1 -1 -1 -1 -1 1 -1 -1 -1;-1 1 -1 1 -1 1 -1 -1 -1 1 -1 -1 1 -1 -1 -1 -1 1 -1 -1;-1 -1 1 -1 1 1 1 -1 -1 -1 -1 -1 -1 1 -1 -1 -1 -1 1 -1;1 -1 -1 1 -1 -1 1 1 -1 -1 -1 -1 -1 -1 1 -1 -1 -1 -1 1];

# ╔═╡ 93954873-6158-4da0-be2d-e3216320dc82
H3 = Rational[1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;1 1 1 1 1 1 1 1 1 1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1;1 1 1 1 1 -1 -1 -1 -1 -1 1 1 1 1 1 -1 -1 -1 -1 -1;1 1 1 1 -1 1 -1 -1 -1 -1 1 -1 -1 -1 -1 1 1 1 1 -1;1 1 1 -1 -1 -1 1 1 -1 -1 -1 1 1 -1 -1 1 1 -1 -1 1;1 1 -1 1 -1 -1 1 1 -1 -1 -1 -1 -1 1 1 -1 -1 1 1 1;1 1 -1 -1 1 1 -1 -1 1 -1 -1 1 -1 1 -1 1 -1 1 -1 1;1 1 -1 -1 1 1 -1 -1 -1 1 -1 -1 1 -1 1 -1 1 -1 1 1;1 1 -1 -1 -1 -1 1 -1 1 1 1 1 -1 -1 1 -1 1 1 -1 -1;1 1 -1 -1 -1 -1 -1 1 1 1 1 -1 1 1 -1 1 -1 -1 1 -1;1 -1 1 1 -1 -1 -1 -1 1 1 -1 1 -1 -1 1 1 -1 -1 1 1;1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 -1 -1 -1 1 1 1;1 -1 1 -1 1 -1 -1 1 -1 1 -1 1 -1 1 -1 -1 1 1 1 -1;1 -1 1 -1 -1 1 1 -1 -1 1 -1 -1 1 1 1 1 -1 1 -1 -1;1 -1 1 -1 -1 1 -1 1 1 -1 1 -1 -1 1 1 -1 1 -1 -1 1;1 -1 -1 1 1 -1 1 -1 -1 1 1 -1 -1 1 -1 1 1 -1 -1 1;1 -1 -1 1 1 -1 -1 1 1 -1 -1 -1 1 -1 1 1 1 1 -1 -1;1 -1 -1 1 -1 1 1 -1 1 -1 -1 1 1 1 -1 -1 1 -1 1 -1;1 -1 -1 1 -1 1 -1 1 -1 1 1 1 1 -1 -1 -1 -1 1 -1 1;1 -1 -1 -1 1 1 1 1 -1 -1 1 1 -1 -1 1 1 -1 -1 1 -1];

# ╔═╡ cd49d76a-f60f-4db8-b3da-e33dbbadad74
matrices = (H1, H2, H3);

# ╔═╡ effb4cdf-c2ac-4475-8376-fb5ac90d50d7
function find_pivot_patterns(matrix_information_filename, pivot_patterns_filename, counts_filename)
	M = stored_pivot_patterns(pivot_patterns_filename);
	m, n = size(M);
	counts_string = readline(counts_filename);
	counts = [parse(Int, i) for i = split(counts_string, ", ")];
	number_of_matrices = sum(counts);
	#Print the results so far (e.g. from previous times the function has been run)
	print("Pivot patterns: ", m, "\nMatrices: ", number_of_matrices, "\n\n");
	while true
		transformation_information = transformation_information_generator(n);
		for index = 1:length(matrices)
			number_of_matrices += 1;
			A = matrices[index];
			pivots = find_pivots(transform(A, transformation_information));
			new_pivot_pattern = true;
			#If this pivot pattern is not new, increase the number of matrices from which it has emerged by 1
			for i = 1:m
				if M[i, :]' == pivots
					new_pivot_pattern = false;
					counts[i] += 1;
					counts_string = string(counts)[2:end-1];
					#Store the results so far (with limited frequency, for efficiency)
					if number_of_matrices%100000 == 0
						open(counts_filename, "w") do f
							write(f, counts_string);
						end
						print("Pivot patterns: ", m, "\nMatrices: ", number_of_matrices, "\nSleeping for 5 seconds, in case program termination is desired.\n");
						sleep(5);
						print("Continuing.\n\n");
					end
					break;
				end
			end
			#If it is new, update the necessary information within the code, store the appropriate information and print the results so far
			if new_pivot_pattern
				m += 1;
				M1 = M;
				M = zeros(Rational, m, n);
				M[1:m-1, :] = M1;
				M[m, :] = pivots;
				push!(counts, 1);
				pivots_string = string(pivots)[9:end];
				counts_string = string(counts_string, ", 1");
				open(matrix_information_filename, "a") do f
					write(f, string("\n", index, ", ", transformation_information));
				end
				open(pivot_patterns_filename, "a") do f
					write(f, "\n", pivots_string);
				end
				open(counts_filename, "w") do f
					write(f, counts_string);
				end
				print("New pivot pattern found: ", pivots_string, "\nPivot patterns: ", m, "\nMatrices: ", number_of_matrices, "\n\n");
			end
		end
	end
end

# ╔═╡ acbedb37-eb77-4540-8f69-d633933ccacf
function print_pivot_patterns_of_initial_matrices()
	for A = matrices
		print(string(find_pivots(A))[9:end], "\n");
	end
end

# ╔═╡ Cell order:
# ╟─8fb67fb0-1414-47df-acae-7ffa1d131ce4
# ╟─870ea327-7a76-4fc8-8c92-a4df03ef9388
# ╟─38d0378b-9703-4b0c-8c48-628f72082889
# ╠═ce66e4fa-3255-4667-ba24-3f04b740a43d
# ╟─42f35a58-98cb-4a25-ab1d-21e144c45881
# ╟─4540be78-9a6d-4832-b171-e68034a74228
# ╠═743ce82f-d94c-43bc-8b91-19bbcc93c70e
# ╟─69f45afe-a66b-4427-b911-a2eef1b6f9e3
# ╠═1bcacd18-7ed7-4113-9501-22ef800334be
# ╟─74cd7923-bed5-4612-89df-0690898eee16
# ╠═5121c70b-512f-4904-9088-dc70aac2a101
# ╟─6ab2c57a-8a22-4103-8080-59785a71f426
# ╠═effb4cdf-c2ac-4475-8376-fb5ac90d50d7
# ╟─aec29195-277f-4bd2-b161-f13ddba59ff8
# ╠═acbedb37-eb77-4540-8f69-d633933ccacf
# ╟─d239ba8e-da2a-49e8-9692-8adaf5701d2a
# ╠═482bc831-c509-4b05-b9c7-57bbc7a67e2e
# ╟─460067cb-e2ad-49fd-bb21-3e4f8fac2b47
# ╠═e638b059-0fcd-46c1-b39e-6d41b60886b2
# ╠═b832c41b-ae9b-49be-9cc2-3d7f92dc45fb
# ╠═93954873-6158-4da0-be2d-e3216320dc82
# ╠═cd49d76a-f60f-4db8-b3da-e33dbbadad74
