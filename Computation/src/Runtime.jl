"""
# module Run

- Julia version:
- Author: anunia
- Date: 2020-04-26

# Examples

```jldoctest
julia>
```
"""
module Run
    import Base.Threads
    import Distributed
    include("JsonReader.jl")


    projectName, modules = JsonReader.upload_modules("Computation/ToUppercase_test.json")
    println(projectName)

    modules_dict = Dict()
    modules_info = Dict()
    tasks = []

    for m in modules
        include("Modules/"*m.functionid*".jl")

        functionCallString = """$(m.functionid)_f("""
        i = 0
        for connection in m.connections.inputs
            if i > 0
                functionCallString = functionCallString * ""","""
            end
            module_in = connection.module_id
            module_port = connection.module_port

            functionCallString = functionCallString * """$(modules[module_in].io.outputs[module_port].channel)"""
            i = i + 1
        end

        for out in m.io.outputs
            if i > 0
                (functionCallString = functionCallString * """,""")
            end
            functionCallString *= """$(out.channel)"""
            i = i + 1
        end
        if i > 0
            (functionCallString = functionCallString * """,""")
        end
        functionCallString = functionCallString * """"$(m.options)")"""
        #
        # in_channels = Dict()
        # out_channels = Dict()
        #
        #     for io in m.io.outputs
        #         out_channels[io.port_id] = io.channel
        #     end
        #     for connection in m.connections.inputs
        #         module_in = connection.module_id
        #         module_port = connection.module_port
        #         input_port = connection.input_port
        #         in_channels[input_port] = modules[module_in].io.outputs[module_port].channel
        #     end
        # modules_dict = Dict("functionid" => m.functionid,"input_channels" => in_channels, "output_channels" => out_channels)
        # modules_info[m.id] = modules_dict
        # string = """$(m.functionid).$(m.functionid)_f(modules_info[$(m.id)]["input_channels"], modules_info[$(m.id)]["output_channels"],"$(m.options)")"""
        # # println(string)
        # push!(tasks,@task (eval(Meta.parse(string))))
        println(string(i) * functionCallString)
        push!(tasks,@task (eval(Meta.parse(functionCallString))))
    end
    # println(modules_info)
    for task in tasks
        schedule( task)
    end
    println("End")
end
