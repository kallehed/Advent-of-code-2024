#import Pkg
#Pkg.add("JuMP")
#Pkg.add("GLPK")

using JuMP
# had to use GLPK to make it work for such big numbers
# as GLPK uses integers to solve it, supposedly 
using GLPK



# first parse the stuff
text = read(stdin, String)

# m at end signals that it could be multiple lines

pattern = r"Button A:\s*X\+(\d+),\s*Y\+(\d+)\s*Button B:\s*X\+(\d+),\s*Y\+(\d+)\s*Prize:\s*X=(\d+),\s*Y=(\d+)"m

numnums = [parse.(Int, m.captures) for m in eachmatch(pattern, text)]
println("yoyo", numnums)
total = Int(0)
for nums in numnums
	println(nums)
        Ax, Ay, Bx, By, Px, Py = nums
	Px += 10000000000000
	Py += 10000000000000
	println("KALLE:", Px, " ", Py)
	# Create the optimization model
	model = Model(GLPK.Optimizer)
	# Define the integer variables A and B, both >= 0
	@variable(model, A >= 0, Int)
	@variable(model, B >= 0, Int)

	# Add the equality constraints
	@constraint(model, Ax * A + Bx * B == Px)
	@constraint(model, Ay * A + By * B == Py)

	# Set the objective to minimize 3*A + B
	@objective(model, Min, 3 * A + B)

	# Solve the model
	optimize!(model)

	# Check the solution status
	if termination_status(model) == MOI.OPTIMAL
	    println("Optimal solution found:")
	    println("A = ", value(A))
	    println("B = ", value(B))
	    println("Objective value = ", objective_value(model))
	    global total += Int(objective_value(model))
	else
	    println("No optimal solution found. Status: ", termination_status(model))
	end
end


println("YOYYO: result: value: ", total)
