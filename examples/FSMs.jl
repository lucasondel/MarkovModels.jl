### A Pluto.jl notebook ###
# v0.19.3

using Markdown
using InteractiveUtils

# ╔═╡ 6e84e042-b5a5-11ec-3bda-e7f5e804b97e
begin
	using Pkg
	Pkg.activate("../")

	using LinearAlgebra
	using Semirings
	using Revise
	using MarkovModels
	using SparseArrays
end

# ╔═╡ 238148e8-dfd8-454f-abb7-9571d09958a6
K = ProbSemiring{Float32}

# ╔═╡ eb27ffd7-2496-4edb-a2b0-e5828278410c
fsm1 = FSM(
	[1 => one(K)], # α
	[(1, 1) => one(K), (1, 2) => one(K), (2, 2) => one(K), (2, 1) => one(K)], # T 
	[2 => one(K)], # ω
	[Label(:1), Label(:2)] # λ
) |> renorm

# ╔═╡ 140ef71a-d95e-4d2b-ad50-7a42c3125d7f
fsm2 = FSM(
	[1 => one(K)],
	[(1, 1) => one(K), (1, 2) => one(K), (2, 2) => one(K), (2, 3) => one(K),
	 (3, 3) => one(K)],
	[3 => one(K)],
	[Label(:1), Label(:2), Label(:3)]
) |> renorm

# ╔═╡ 56faf31f-32a3-4ef2-a094-06f5a2987ab6
union(fsm1, fsm2)

# ╔═╡ 813026d5-6171-4749-b6e2-b38e67a78e9f
cat(fsm1, fsm2)

# ╔═╡ 7d0e5b1e-9928-441e-9f63-f0aa55a87e9e
fsm1.α .* fsm1.ω'

# ╔═╡ 9e09acd6-780c-44f2-866a-070b10a46c7b
fsm = FSM(
	[1 => one(K) + one(K), 2 => one(K)],
	[(1, 2) => one(K), (2, 1) => one(K)],
	[1 => one(K)],
	[Label(:a), Label(:b)]
) |> renorm

# ╔═╡ c29c020d-829d-4f5f-804b-f0d6591329fc
fsm ∘ [fsm1 |> renorm, fsm2 |> renorm]

# ╔═╡ 31319623-6804-405d-ba65-b909d74092f2
vcat((ones(2) for i in 1:4)...)

# ╔═╡ 784849b6-256a-430f-8815-09a67414c363
zero(fsm.α)

# ╔═╡ b74cfd41-7bf4-4a51-a9f7-6142aa220f6d
md"""
## Determinization
"""

# ╔═╡ 4c7d472e-c69b-4757-9e6c-5444e6ca5751
fsma = FSM(
	[1 => one(K)],
	[(1, 2) => one(K), (1, 3) => K(4), (2, 4) => one(K), (3, 4) => one(K)],
	[4 => one(K)],
	[Label(:a), Label(:b), Label(:b), Label(:c)]
) 

# ╔═╡ c851bfc7-7de1-4b9c-9b34-c3b1bf233d90
fsmb = FSM(
	[1 => one(K)+one(K)],
	[(1, 2) => one(K), (1, 3) => one(K), (2, 4) => one(K), (3, 4) => K(2)],
	[4 => one(K)],
	[Label(:a), Label(:b), Label(:d), Label(:c)]
) 

# ╔═╡ a175fc9e-5330-4e54-854c-7b14d125ec71
fsmc = FSM(
	[1 => one(K)],
	[(1, 2) => K(2), (2, 3) => one(K)],
	[3 => one(K)],
	[Label(:b), Label(:a), Label(:c)]
) 

# ╔═╡ 49e645e1-a8a1-48ba-b032-770d5dcf78ba
fsmabc = (fsma ∪ fsmb ∪ fsmc) 

# ╔═╡ 96be6364-e98f-4ba6-8856-a5ace0646b48
determinize(fsmabc |> propagate) |> renorm

# ╔═╡ d7045fe6-bb47-4874-b3c4-cbf0bc584b5b
minimize(fsmabc |> propagate) |> renorm

# ╔═╡ 5fb089a3-073b-4ba9-acbc-4d34d8880dae
determinize(fsmabc) |> renorm

# ╔═╡ d89c32d4-0d92-4172-89dd-17cf24a9f9a9
fsmabc.T' * fsmabc.T

# ╔═╡ 307dbf5a-aa62-4ca2-a01c-da3a42644194
fsmabc.T^2

# ╔═╡ 29066579-1048-4ca2-a28f-413d77a8eaed
f = minimize(fsmabc) #|> renorm

# ╔═╡ 5fdc07f7-374e-43ea-89aa-51f4f4a4b011
totallabelsum(fsmabc, 10) == totallabelsum(dfsm, 10) 

# ╔═╡ 3e5e8565-4713-4b0e-a0e7-b43385296c09
totalweightsum(dfsm |> renorm, 10) 

# ╔═╡ 309423ca-a2ce-48bf-8443-7b7680666db1
totalweightsum(fsmabc |> renorm, 10)

# ╔═╡ 041ac2d1-9be4-4edd-a18b-2a88330eb873
totalweightsum(fsmabc, 10) == totalweightsum(dfsm , 10) 

# ╔═╡ 3782f595-e531-45dd-97b8-722b7804690a
fsm.T * diagm(fsm.α)

# ╔═╡ 5e0251c9-05eb-4c56-8824-4f65acdd1dbb


# ╔═╡ 91477ae0-5ca9-4652-99ae-fb86404738a7
totallabelsum(dfsm, 4)

# ╔═╡ 2bb572c9-eb7a-49a3-9e2f-c7774016b81c
MarkovModels.tobinary(UnionConcatSemiring, fsm.T)

# ╔═╡ ccdba532-60ac-4a85-97b9-7f3dcfc705fa
fsmabc.T' * fsmabc.α 

# ╔═╡ acda1bdf-a59e-447f-910f-97d69809eb92
sum(fsmabc.α[collect(s1)])

# ╔═╡ 3255a509-fbae-4f4e-b044-31d934c9f511
fsmabc.α[collect((2, 1, 1))]

# ╔═╡ 0b48f478-ef5a-41bd-a180-c90d91e8b3ae
typeof(j)

# ╔═╡ 701addca-356a-4026-bc00-c0c62bd61f4a
fsmabc.T[1, :] + fsmabc.T[5, :]

# ╔═╡ f5352a72-35ea-46e8-98c9-30e2f86df419


# ╔═╡ 25b2bc7f-1345-4138-8657-512d776043dd
nonzeros(Ml' * al)[1]

# ╔═╡ ff7f956f-5575-4ffd-b6b9-41cd4823dfe4


# ╔═╡ 23952906-e471-4de6-8b29-9cca2e36e506
B = Tl * Ml

# ╔═╡ f31d9b28-9f7b-4e8d-9de8-fb962bd96837
i = Ml' * al

# ╔═╡ 9edcc5f7-0907-43eb-87f1-67283aec125d
sort(map(first, collect(val(i[1]))))

# ╔═╡ a6dc9320-7c80-49b7-ac65-4bc5f9fdf67f
tuple(sort(collect(i[1].val))...)

# ╔═╡ f8c85a25-1f7a-43be-ade1-6a291479b3b8
B[1, :] + B[5, :]

# ╔═╡ 4a16a8ab-83d1-4f62-98d9-c0c617fabd91
fsmabc.λ[1]

# ╔═╡ 8d0ce19d-c4bc-4b3a-8ba5-b0a11420e329
sum(fsmabc.λ).val

# ╔═╡ 7ceba44f-27d4-43e0-9b52-b4d68ddfcdda
z = [Label(i) for i in 1:length(fsmab.α)]

# ╔═╡ 61cc7a22-a893-4a5e-a875-16ab43686023
ML = MarkovModels.tobinary(UnionConcatSemiring, fsmab.T)

# ╔═╡ be3eb371-7a04-4326-948f-1ffacb005f14
αL = MarkovModels.tobinary(UnionConcatSemiring, fsmab.α)

# ╔═╡ ec291d41-8382-4154-9df8-a1a991603446
l = αL .* z

# ╔═╡ cdec2e91-8eb4-4fa1-a237-23b1f91574b9
begin
	I, J, V = [], [], UnionConcatSemiring[]
	Q = length(fsmab.α)
	for i in 1:Q, j in i:Q
		if fsmab.λ[i] == fsmab.λ[j] 
			push!(I, i)
			push!(J, j)
			push!(V, one(UnionConcatSemiring))
		end
	end
	M = sparse(I, J, V, Q, Q)
end

# ╔═╡ 3f4d487a-02bd-4bda-a5f8-3e90be439481
M' * l

# ╔═╡ c749092f-d7b1-45b4-b77a-f6792d27a2a6
one(K) * false

# ╔═╡ c2c25125-cc7f-423d-9ce1-b48e06b477ae
Tₗ = (MarkovModels.tobinary(UnionConcatSemiring, fsm1.T) * diagm(fsm1.λ))

# ╔═╡ 9cf291cb-8e2e-404c-9a93-c3cbd5a8f8b8
αₗ = MarkovModels.tobinary(UnionConcatSemiring, fsm1.α)

# ╔═╡ 16f1e618-a09f-4dfe-a043-fbd53394094c
v = αₗ .* fsm1.λ

# ╔═╡ 05b82f72-7782-4e04-9574-04aeb142e4c3
dot(fsm1.α, fsm1.ω)

# ╔═╡ c70e0b16-9a2c-4c43-a79f-02322323b261
totalsum(fsm1, 10)

# ╔═╡ 674c7ba1-19f9-448f-aafb-ab3674f23fca
totallabelsum(fsm1, 2)

# ╔═╡ d67ce556-0f5d-414e-b6f9-251282ef71ff
v' * Tₗ

# ╔═╡ d9cda305-1571-4f66-9875-98443b318c1a
Tₗ[3] * v[1]

# ╔═╡ 522bc9aa-4ce9-4f9f-a516-d843a1e0609e
v[1] * Tₗ[3]

# ╔═╡ 27f2175f-985f-419d-819f-58e101554d2d
g[:, 1] .+  sparsevec(t) 

# ╔═╡ 0d8f1915-d2fc-456d-acc1-006ded794478
sparsevec(l)

# ╔═╡ 8ae7342a-a7a9-4b65-aad7-91e641b5cfef
M * sparse(l[:, :])

# ╔═╡ fedc5764-3115-4004-b71d-a17279aa7b4c
sprandn(10, 10, 0.1) * randn(10)

# ╔═╡ 46f419a6-d320-4bd6-a26e-f78aa9866f3e
one(UnionConcatSemiring)  + fsm1.λ[1]

# ╔═╡ 70ad22a7-6c95-4079-859b-9eacf77e9a91
2*0.166 + 0.666

# ╔═╡ 2afa17db-fbff-45b2-b2a9-c4c2ac907121
D = vcat(hcat(fsm.T, fsm.ω), zeros(K, 1, length(fsm.ω)+1))

# ╔═╡ 18847048-c67c-4058-a004-210b6ac48dd2
D[end,end] = 1

# ╔═╡ dc98646a-2d8b-419c-b639-f205ee012c0c
D

# ╔═╡ 841fc7d7-48d4-4c44-b322-cdf486717770
one(UnionConcatSemiring)

# ╔═╡ edfaeb45-37fd-4dd0-94cf-1fd7fdf49260
zero(UnionConcatSemiring)

# ╔═╡ 96911c39-f871-41e8-b83d-05f4633ce58e
A11 = A12 = A21 = A22 = rand(4, 4);

# ╔═╡ 49a51adb-f41a-42d5-8dec-363d19a96825
[A11  zero(A11);
 zero(A11) A22]

# ╔═╡ 87223769-e9ef-4982-bc4a-d90d63931df2
zero(A11)

# ╔═╡ 78d44e1d-ab26-4ccd-b518-401b6a3bbf5a
y = sparse(1:3, ones(3), 2*ones(3))

# ╔═╡ b04a2028-9233-4016-b834-3895df3b7a9e
blockdiag(y, y, y)

# ╔═╡ 657e4548-c776-4f23-a1b6-128d898fc155
prod(fsm.λ) .+ fsm.λ

# ╔═╡ 90c714f7-9389-4c45-a4a9-8cea264e9b40
(fsm.λ[1] * fsm.λ[2] + fsm.λ[3])

# ╔═╡ 4023155a-3b3d-4fb8-9b62-5a4772d7306b
fsm.α[3] == zero(K)

# ╔═╡ f883eddd-3469-49ba-8614-6768f11492f5
zero(fsm.α[3])

# ╔═╡ 546f7484-c945-4fa7-bc07-1099bf7b7591
x = ProbSemiring[1.0, 0.0, 0]

# ╔═╡ e9b896e4-46ba-484f-8bff-0c463228b77a
UnionConcatSemiring(Set([SymbolSequence([:a, :b, :c])]))

# ╔═╡ 0fbe3317-3d24-41fc-84ca-028766731083
nonzeros

# ╔═╡ ad3b9922-601c-4ec3-81d2-f91df8b7c42c
join([1, 2, 3])

# ╔═╡ Cell order:
# ╠═6e84e042-b5a5-11ec-3bda-e7f5e804b97e
# ╠═238148e8-dfd8-454f-abb7-9571d09958a6
# ╠═eb27ffd7-2496-4edb-a2b0-e5828278410c
# ╠═140ef71a-d95e-4d2b-ad50-7a42c3125d7f
# ╠═56faf31f-32a3-4ef2-a094-06f5a2987ab6
# ╠═813026d5-6171-4749-b6e2-b38e67a78e9f
# ╠═7d0e5b1e-9928-441e-9f63-f0aa55a87e9e
# ╠═9e09acd6-780c-44f2-866a-070b10a46c7b
# ╠═c29c020d-829d-4f5f-804b-f0d6591329fc
# ╠═31319623-6804-405d-ba65-b909d74092f2
# ╠═784849b6-256a-430f-8815-09a67414c363
# ╟─b74cfd41-7bf4-4a51-a9f7-6142aa220f6d
# ╠═4c7d472e-c69b-4757-9e6c-5444e6ca5751
# ╠═c851bfc7-7de1-4b9c-9b34-c3b1bf233d90
# ╠═a175fc9e-5330-4e54-854c-7b14d125ec71
# ╠═49e645e1-a8a1-48ba-b032-770d5dcf78ba
# ╠═96be6364-e98f-4ba6-8856-a5ace0646b48
# ╠═d7045fe6-bb47-4874-b3c4-cbf0bc584b5b
# ╠═5fb089a3-073b-4ba9-acbc-4d34d8880dae
# ╠═d89c32d4-0d92-4172-89dd-17cf24a9f9a9
# ╠═307dbf5a-aa62-4ca2-a01c-da3a42644194
# ╠═29066579-1048-4ca2-a28f-413d77a8eaed
# ╠═5fdc07f7-374e-43ea-89aa-51f4f4a4b011
# ╠═3e5e8565-4713-4b0e-a0e7-b43385296c09
# ╠═309423ca-a2ce-48bf-8443-7b7680666db1
# ╠═041ac2d1-9be4-4edd-a18b-2a88330eb873
# ╠═3782f595-e531-45dd-97b8-722b7804690a
# ╠═5e0251c9-05eb-4c56-8824-4f65acdd1dbb
# ╠═91477ae0-5ca9-4652-99ae-fb86404738a7
# ╠═2bb572c9-eb7a-49a3-9e2f-c7774016b81c
# ╠═ccdba532-60ac-4a85-97b9-7f3dcfc705fa
# ╠═acda1bdf-a59e-447f-910f-97d69809eb92
# ╠═3255a509-fbae-4f4e-b044-31d934c9f511
# ╠═0b48f478-ef5a-41bd-a180-c90d91e8b3ae
# ╠═701addca-356a-4026-bc00-c0c62bd61f4a
# ╠═f5352a72-35ea-46e8-98c9-30e2f86df419
# ╠═25b2bc7f-1345-4138-8657-512d776043dd
# ╠═ff7f956f-5575-4ffd-b6b9-41cd4823dfe4
# ╠═23952906-e471-4de6-8b29-9cca2e36e506
# ╠═f31d9b28-9f7b-4e8d-9de8-fb962bd96837
# ╠═9edcc5f7-0907-43eb-87f1-67283aec125d
# ╠═a6dc9320-7c80-49b7-ac65-4bc5f9fdf67f
# ╠═f8c85a25-1f7a-43be-ade1-6a291479b3b8
# ╠═4a16a8ab-83d1-4f62-98d9-c0c617fabd91
# ╠═8d0ce19d-c4bc-4b3a-8ba5-b0a11420e329
# ╠═7ceba44f-27d4-43e0-9b52-b4d68ddfcdda
# ╠═61cc7a22-a893-4a5e-a875-16ab43686023
# ╠═be3eb371-7a04-4326-948f-1ffacb005f14
# ╠═ec291d41-8382-4154-9df8-a1a991603446
# ╠═cdec2e91-8eb4-4fa1-a237-23b1f91574b9
# ╠═3f4d487a-02bd-4bda-a5f8-3e90be439481
# ╠═c749092f-d7b1-45b4-b77a-f6792d27a2a6
# ╠═c2c25125-cc7f-423d-9ce1-b48e06b477ae
# ╠═9cf291cb-8e2e-404c-9a93-c3cbd5a8f8b8
# ╠═16f1e618-a09f-4dfe-a043-fbd53394094c
# ╠═05b82f72-7782-4e04-9574-04aeb142e4c3
# ╠═c70e0b16-9a2c-4c43-a79f-02322323b261
# ╠═674c7ba1-19f9-448f-aafb-ab3674f23fca
# ╠═d67ce556-0f5d-414e-b6f9-251282ef71ff
# ╠═d9cda305-1571-4f66-9875-98443b318c1a
# ╠═522bc9aa-4ce9-4f9f-a516-d843a1e0609e
# ╠═27f2175f-985f-419d-819f-58e101554d2d
# ╠═0d8f1915-d2fc-456d-acc1-006ded794478
# ╠═8ae7342a-a7a9-4b65-aad7-91e641b5cfef
# ╠═fedc5764-3115-4004-b71d-a17279aa7b4c
# ╠═46f419a6-d320-4bd6-a26e-f78aa9866f3e
# ╠═70ad22a7-6c95-4079-859b-9eacf77e9a91
# ╠═2afa17db-fbff-45b2-b2a9-c4c2ac907121
# ╠═18847048-c67c-4058-a004-210b6ac48dd2
# ╠═dc98646a-2d8b-419c-b639-f205ee012c0c
# ╠═841fc7d7-48d4-4c44-b322-cdf486717770
# ╠═edfaeb45-37fd-4dd0-94cf-1fd7fdf49260
# ╠═96911c39-f871-41e8-b83d-05f4633ce58e
# ╠═49a51adb-f41a-42d5-8dec-363d19a96825
# ╠═87223769-e9ef-4982-bc4a-d90d63931df2
# ╠═78d44e1d-ab26-4ccd-b518-401b6a3bbf5a
# ╠═b04a2028-9233-4016-b834-3895df3b7a9e
# ╠═657e4548-c776-4f23-a1b6-128d898fc155
# ╠═90c714f7-9389-4c45-a4a9-8cea264e9b40
# ╠═4023155a-3b3d-4fb8-9b62-5a4772d7306b
# ╠═f883eddd-3469-49ba-8614-6768f11492f5
# ╠═546f7484-c945-4fa7-bc07-1099bf7b7591
# ╠═e9b896e4-46ba-484f-8bff-0c463228b77a
# ╠═0fbe3317-3d24-41fc-84ca-028766731083
# ╠═ad3b9922-601c-4ec3-81d2-f91df8b7c42c
