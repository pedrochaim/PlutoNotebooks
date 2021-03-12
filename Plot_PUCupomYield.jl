### A Pluto.jl notebook ###
# v0.12.21

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

# ╔═╡ 4e7da570-8358-11eb-0dcf-572b7751acc5
begin
	import Pkg
	Pkg.activate(mktempdir())
	Pkg.add("PlutoUI")
	using PlutoUI
	Pkg.add("Plots")
	Pkg.add("LaTeXStrings")
	Pkg.add("StatsBase")
	using Plots
	using LaTeXStrings
	using StatsBase
	gr(framestyle=:origin,
	grid=false,
	linewidth=1,
	legendfontsize=12,
	size=(600,400))
end

# ╔═╡ a3151c0e-8364-11eb-19e1-c54e31150bcd
function PUCupomTempoPlot(;T=5, c=.1, y=.08, tipo=1)
	FV = 1000
	PMT = c*FV
	CFs = PMT*ones(T-1)
	push!(CFs,FV*(1+c))
	PV_CFs =CFs./(1+y).^(1:T)
	
	
	function PV(CFs,y)
		N = length(CFs)
		PV_CFs = sum(CFs./(1+y).^(1:N))
	end
	
	PU_0 = PV(CFs,y)
	PUs = zeros(T)
	for t ∈ 1:(T-1)
		PUs[t] = PV(CFs[(t+1):T],y)
	end
	PUs[end] = FV*(1+c)
	PUs = [PU_0; PUs]
	
	
	
	plt1 = plot(0:T, PUs, t=:scatter, label="PUₜ")
	plot!(1:T, CFs, t=:stem, arrow=T, label="CFₜ")
	yticks!(round.([PMT,PUs[1], PUs[end-1], PUs[end]],digits=2))
	hline!(round.([PUs[1], PUs[end-1], PUs[end]],digits=2),color=:gray, ls=:dash,label=false)

	ganho_capital = PUs[2:T+1]./PUs[1:T].-1
	c_yield = PMT./PUs
	c_yield = c_yield[1:end-2]
	push!(c_yield,0)
	retorno_periodo = ganho_capital + c_yield
	
	plt2 = plot(1:T, 100*retorno_periodo, t=:scatter, label="Retorno Total: Ret = g + cy",ylab="% ao ano", xlab="t (anos)", legend=:outertop)
		plot!(1:T, 100*ganho_capital, t=:scatter, label="Ganho de Capital: g = (PUₜ/PUₜ-₁)-1")
		plot!(1:T, 100*c_yield, t=:scatter, label = "Current Yield: cy = PMT/PUₜ-₁")
	
	hline!([100*retorno_periodo[1]], color=1, alpha=0.5, label="")
	tipo==1 && return plt1
	tipo==2 && return plt2
	
end

# ╔═╡ a8674300-8364-11eb-23e0-41292cc712a8
md"""
* Valor de Face: ``FV=\$1000``
* Taxa de Cupom: ``c =``  $(@bind c Slider(0.01:0.01:0.25, default=0.1,show_value=true))
* Maturidade: ``T=`` $(@bind T Slider(2:1:20, default=5,show_value=true))
* Retorno requerido: ``y =`` $(@bind y Slider(0.01:0.01:0.25, default=0.01,show_value=true))
"""

# ╔═╡ acf50880-8364-11eb-1b65-7d295e4ac84b
PUCupomTempoPlot(T=T,c=c,y=y)

# ╔═╡ af721670-8364-11eb-3a6f-4bf802d8a11a
PUCupomTempoPlot(T=T,c=c,y=y, tipo=2)

# ╔═╡ Cell order:
# ╟─4e7da570-8358-11eb-0dcf-572b7751acc5
# ╟─a3151c0e-8364-11eb-19e1-c54e31150bcd
# ╟─a8674300-8364-11eb-23e0-41292cc712a8
# ╠═acf50880-8364-11eb-1b65-7d295e4ac84b
# ╠═af721670-8364-11eb-3a6f-4bf802d8a11a
