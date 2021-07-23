var documenterSearchIndex = {"docs":
[{"location":"fsm/#Finite-State-Machines","page":"Finite State Machines","title":"Finite State Machines","text":"","category":"section"},{"location":"fsm/","page":"Finite State Machines","title":"Finite State Machines","text":"The MarkovModels package represents Markov chains as probabilistic a Finite State Machine (FSM).  Here is an example of FSM as used by the package:","category":"page"},{"location":"fsm/","page":"Finite State Machines","title":"Finite State Machines","text":"(Image: missing image)","category":"page"},{"location":"fsm/","page":"Finite State Machines","title":"Finite State Machines","text":"The thick line node indicates the starting state whereas the double line node indicates the ending states.","category":"page"},{"location":"fsm/","page":"Finite State Machines","title":"Finite State Machines","text":"note: Note\nTo be able to visualize FSMs as in the example above when using IJulia, make sure that the dot program (from graphviz) is available in your shell PATH variable. Also, you won't be able to visualize the FSM in the REPL.","category":"page"},{"location":"fsm/","page":"Finite State Machines","title":"Finite State Machines","text":"In the following, we present the tools provided by the package manipulate such FSM. All the examples below assume that you have already imported the MarkovModels.jl package by doing using MarkovModels.","category":"page"},{"location":"fsm/#Creating-FSMs","page":"Finite State Machines","title":"Creating FSMs","text":"","category":"section"},{"location":"fsm/","page":"Finite State Machines","title":"Finite State Machines","text":"FSMs are represented by the following structure:","category":"page"},{"location":"fsm/","page":"Finite State Machines","title":"Finite State Machines","text":"FSM","category":"page"},{"location":"fsm/#MarkovModels.FSM","page":"Finite State Machines","title":"MarkovModels.FSM","text":"struct FSM{T<:Semifield}\n    states # vector of states\n    links # Dict state -> vector of links\nend\n\nProbabilistic finite state machine.\n\n\n\n\n\n","category":"type"},{"location":"fsm/","page":"Finite State Machines","title":"Finite State Machines","text":"Our FSMs operate in the log-semifield where each number can be interpreted as a log-probability. The package provide the following type:","category":"page"},{"location":"fsm/","page":"Finite State Machines","title":"Finite State Machines","text":"T = Float64\nSF = LogSemifield{T}","category":"page"},{"location":"fsm/","page":"Finite State Machines","title":"Finite State Machines","text":"Then, too create an FSM object simply type:","category":"page"},{"location":"fsm/","page":"Finite State Machines","title":"Finite State Machines","text":"fsm = FSM{SF}()","category":"page"},{"location":"fsm/","page":"Finite State Machines","title":"Finite State Machines","text":"When created, the FSM has only two states: the initial state and the final state. FSMs cannot have multiple initial for final states.","category":"page"},{"location":"fsm/","page":"Finite State Machines","title":"Finite State Machines","text":"You can add states to the FSM by using the function addstate!:","category":"page"},{"location":"fsm/","page":"Finite State Machines","title":"Finite State Machines","text":"s1 = addstate!(fsm, pdfindex = 1)\ns2 = addstate!(fsm, pdfindex = 2, label = \"a\")\ns3 = addstate!(fsm, label = \"b\")\ns4 = addstate!(fsm)","category":"page"},{"location":"fsm/","page":"Finite State Machines","title":"Finite State Machines","text":"(Image: missing image)","category":"page"},{"location":"fsm/","page":"Finite State Machines","title":"Finite State Machines","text":"Note that a state can be:","category":"page"},{"location":"fsm/","page":"Finite State Machines","title":"Finite State Machines","text":"emitting and labeled\nemitting only\nlabeled only\nnon-emitting and non-labeled (nil state)","category":"page"},{"location":"fsm/","page":"Finite State Machines","title":"Finite State Machines","text":"You also need to define which state is a starting state and which one is an ending state (there can be several starting/ending states):","category":"page"},{"location":"fsm/","page":"Finite State Machines","title":"Finite State Machines","text":"setinit!(s1)\nsetfinal!(s4)","category":"page"},{"location":"fsm/","page":"Finite State Machines","title":"Finite State Machines","text":"(Image: missing image)","category":"page"},{"location":"fsm/","page":"Finite State Machines","title":"Finite State Machines","text":"The link! function add weighted arcs between states:","category":"page"},{"location":"fsm/","page":"Finite State Machines","title":"Finite State Machines","text":"link!(fsm, s1, s1, SF(log(1/2)))\nlink!(fsm, s1, s2, SF(log(1/2)))\nlink!(fsm, s2, s3)\nlink!(fsm, s3, s4)","category":"page"},{"location":"fsm/","page":"Finite State Machines","title":"Finite State Machines","text":"(Image: missing image)","category":"page"},{"location":"fsm/#FSM-operations","page":"Finite State Machines","title":"FSM operations","text":"","category":"section"},{"location":"fsm/#Composition","page":"Finite State Machines","title":"Composition","text":"","category":"section"},{"location":"fsm/","page":"Finite State Machines","title":"Finite State Machines","text":"compile\ndeterminize\ngpu\nminimize\nrenormalize!\nreplace(::FSM{T}, ::Dict) where T\ntranspose","category":"page"},{"location":"fsm/#MarkovModels.compile","page":"Finite State Machines","title":"MarkovModels.compile","text":"compile(fsm; allocator = spzeros)\n\nCompile fsm into a inference-friendly format CompiledFSM. allocator is a function analogous to zeros which creates an N-dimensional array and fills it with zero elements.\n\n\n\n\n\n","category":"function"},{"location":"fsm/#MarkovModels.determinize","page":"Finite State Machines","title":"MarkovModels.determinize","text":"determinize(fsm)\n\nDeterminize the FSM w.r.t. the state labels.\n\n\n\n\n\n","category":"function"},{"location":"fsm/#MarkovModels.gpu","page":"Finite State Machines","title":"MarkovModels.gpu","text":"gpu(cfsm)\n\nMove the compiled fsm cfsm to GPU.\n\n\n\n\n\n","category":"function"},{"location":"fsm/#MarkovModels.minimize","page":"Finite State Machines","title":"MarkovModels.minimize","text":"minimize(fsm)\n\nReturn a minimal equivalent fsm.\n\n\n\n\n\n","category":"function"},{"location":"fsm/#MarkovModels.renormalize!","page":"Finite State Machines","title":"MarkovModels.renormalize!","text":"renormalize!(fsm)\n\nEnsure the that all the weights of all the outgoing arcs leaving a state sum up to 1.\n\n\n\n\n\n","category":"function"},{"location":"fsm/#Base.replace-Union{Tuple{T}, Tuple{FSM{T}, Dict}} where T","page":"Finite State Machines","title":"Base.replace","text":"replace(fsm, subfsms, delim = \"!\")\n\nReplace the state in fsm wiht a sub-fsm from subfsms. The pairing is done with the last tone of label of the state, i.e. the state with label a!b!c will be replaced by subfsms[c]. States that don't have matching labels are left untouched.\n\n\n\n\n\n","category":"method"},{"location":"fsm/#Base.transpose","page":"Finite State Machines","title":"Base.transpose","text":"transpose(fsm)\n\nReverse the direction of the arcs.\n\n\n\n\n\n","category":"function"},{"location":"#MarkovModels-Documentation","page":"Home","title":"MarkovModels Documentation","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"MarkovModels is a Julia package to use (Hidden) Markov Models for probabilistic inference.","category":"page"},{"location":"","page":"Home","title":"Home","text":"See the project on github.","category":"page"},{"location":"","page":"Home","title":"Home","text":"To quickly get started, have a look at the examples:","category":"page"},{"location":"","page":"Home","title":"Home","text":"notebook demo\nbenchmark","category":"page"},{"location":"#Authors","page":"Home","title":"Authors","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Lucas Ondel\nMartin Kocour","category":"page"},{"location":"#Installation","page":"Home","title":"Installation","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"The package can be installed with the Julia package manager. From the Julia REPL, type ] to enter the Pkg REPL mode and run:","category":"page"},{"location":"","page":"Home","title":"Home","text":"pkg> add MarkovModels","category":"page"},{"location":"#Manual-Outline","page":"Home","title":"Manual Outline","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Pages = [\"fsm.md\", \"inference.md\"]","category":"page"},{"location":"inference/#Inference","page":"Inference","title":"Inference","text":"","category":"section"},{"location":"inference/#Baum-Welch-algoritm-(forward-backward)","page":"Inference","title":"Baum-Welch algoritm (forward-backward)","text":"","category":"section"},{"location":"inference/","page":"Inference","title":"Inference","text":"The Baum-Welch algorithm computes the probability to be in a state i at time n:","category":"page"},{"location":"inference/","page":"Inference","title":"Inference","text":"p(z_n = i  x_1  x_N)","category":"page"},{"location":"inference/","page":"Inference","title":"Inference","text":"It is implemented by the αβrecursion function.","category":"page"},{"location":"inference/","page":"Inference","title":"Inference","text":"αβrecursion","category":"page"}]
}
