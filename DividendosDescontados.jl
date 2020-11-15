### A Pluto.jl notebook ###
# v0.12.10

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ e380a102-247a-11eb-1817-e7a457af2795
begin
	import Pkg
	Pkg.activate(mktempdir())
	Pkg.add("PlutoUI")
	Pkg.add("Plots")
	Pkg.add("PyPlot")
	using PlutoUI
	using Plots
	pyplot()
	default(legendfontsize = 16,
		tickfont = 14,
		titlefontsize = 18,
		linewidth=2,
		size=(600,400))
end

# ╔═╡ 21563fd0-247b-11eb-1b1b-03359570b980
function PlotDividendosSemCrescimento(D,r)
	T = 20
	DD = Array{Float64,1}(undef,T)
	DD[1:end] .= D
	plot(1:T, DD, t=:stem, arrow=true, label="D")
	plot!(1:T,DD./(1+r).^collect(1:T), t=:stem, arrow=true, label="PV(Dₜ)")
	#plot!([0],[D/r], t=:scatter, label="P=D/r")
end

# ╔═╡ 2c3c9fc0-247b-11eb-189b-53b42e3ac2e7
md"""
### Modelo de Dividendos Descontados sem Crescimento

``$ P_0 = \sum^\infty_{t=1} \frac{D}{(1+r)^t} = \frac{D}{r}$``

* #### Valor dos Dividendos: `D = ` $(@bind D NumberField(1:20, default=2))
* #### Taxa de Retorno Requerida: `r = ` $(@bind r NumberField(0.00:0.01:0.5, default=0.05)) ao período
"""


# ╔═╡ 345dc530-247b-11eb-0ef4-d3b8cc5567ef
md"""
* #### Valor Intrínseco segundo a fórmula: `P₀ = ` $(round(D/r))
"""

# ╔═╡ 3920082e-247b-11eb-1fb8-23456250afb7
PlotDividendosSemCrescimento(D,r)

# ╔═╡ 50b4f300-247d-11eb-3908-b103709910f1
function PlotDividendosComCrescimento(D,r,g)
	T = 20
	DD = Array{Float64,1}(undef,T)
	DD[1:end] .= D.*(1+g).^collect(1:T)
	plot(1:T, DD, t=:stem, arrow=true, label="Dₜ=Dₜ₋₁(1+g)")
	plot!(1:T,DD./(1+r).^collect(1:T), t=:stem, arrow=true, label="PV(Dₜ)")
end

# ╔═╡ e9c38930-247d-11eb-2da9-0792b3c6a411
md"""
### Modelo de Dividendos Descontados com Crescimento Constante
* #### Valor dos Dividendos: `D = ` $(@bind D2 NumberField(1:20, default=2))
* #### Taxa de Retorno Requerida: `r = ` $(@bind r2 NumberField(0.0:0.01:0.5, default=0.05)) ao período
* #### Taxa de Crescimento dos Dividendos `g = ` $(@bind g NumberField(0.0:0.01:0.5, default=0.05))
"""

# ╔═╡ 60dede70-247e-11eb-1dbd-113b35c2ec0f
md"""
* #### Valor Intrínseco segundo a fórmula: `P₀ = ` $(round(D2/(r2-g)))
"""

# ╔═╡ 78e1ada0-247d-11eb-20ca-79ee5d64a10e
PlotDividendosComCrescimento(D2,r2,g)

# ╔═╡ dc3046d0-247f-11eb-0293-11789ec30dde
md"""
### Formação da taxa de crescimento

``$ g = ROE \cdot b$``

Uma maneira de pensar na formação taxa de crescimento dos lucros o produto entre
* a taxa de lucro dos novos projetos de investimento da empresa, e
* a proporção dos lucros que é retida e direcionada para novos investimentos.

O que quero ilustrar aqui é que maior proporção de dividendos distribuídos não precisa implicar em aumento do preço da ação da empresa.

O $ROE$ (*Return on Equity*, Retorno sobre o Patrimônio Líquido) é definido como
`` $ROE = \frac{\text{Lucro Líquido do Exercício}}{\text{Patrimônio Líquido}}$ ``
O $ROE$ é uma medida que se aproxima da "taxa de lucro dos novos projetos", já que divide o lucro do exercício pelos recursos dos donos da empresa. 

Existe uma suposição aqui, herdada do modelo de Gordon, de que o lucro da empresa sempre aumenta uma proporção fixa, então faz sentido que a taxa de retorno de novos lucros incorporados seja constante também. Ou seja, supomos $ROE$ constante.

O parâmetro $b$ é "um menos a taxa de *payout*". É a proporção dos lucros correntes que não é distribuída em dividendos


"""

# ╔═╡ 44f3aa1e-2482-11eb-3b2d-0bc2a2dec903
md"""
* #### Taxa de Retorno Requerida: `r = ` $(@bind r3 NumberField(0.00:0.01:0.5, default=0.2)) ao período
* #### *Return on Equity* `ROE = ` $(@bind ROE NumberField(0.00:0.01:0.5, default=0.15))
* #### Proporção de Lucros Retidos `b = ` $(@bind b NumberField(0.00:0.05:1.0, default=0.50))
"""

# ╔═╡ 52a721e0-2484-11eb-1a6a-f7501c3b3db8
md"""
* #### Taxa de Crescimento dos Dividendos `g = ROE⋅b = ` $(round(ROE*b,digits=3))
"""

# ╔═╡ 1cd84d40-2485-11eb-030a-27ce78e27f26
begin
	P₀ = round(1/(r3-ROE*b), digits=3)
	PlotDividendosComCrescimento(1,r3,ROE*b)
	title!("P₀ = D/(r-g) = $P₀")
end

# ╔═╡ Cell order:
# ╠═e380a102-247a-11eb-1817-e7a457af2795
# ╠═21563fd0-247b-11eb-1b1b-03359570b980
# ╠═2c3c9fc0-247b-11eb-189b-53b42e3ac2e7
# ╠═345dc530-247b-11eb-0ef4-d3b8cc5567ef
# ╠═3920082e-247b-11eb-1fb8-23456250afb7
# ╠═50b4f300-247d-11eb-3908-b103709910f1
# ╠═e9c38930-247d-11eb-2da9-0792b3c6a411
# ╟─60dede70-247e-11eb-1dbd-113b35c2ec0f
# ╠═78e1ada0-247d-11eb-20ca-79ee5d64a10e
# ╠═dc3046d0-247f-11eb-0293-11789ec30dde
# ╠═44f3aa1e-2482-11eb-3b2d-0bc2a2dec903
# ╠═52a721e0-2484-11eb-1a6a-f7501c3b3db8
# ╠═1cd84d40-2485-11eb-030a-27ce78e27f26
