
############################################
#   Function counting mean of the numbers received by input Channel
#   Receiving "end" finishes reading the numbers
function Mean_f(inPort1, outPort1, options)
    import Statistics

    # numberOfInputs = 0

    numbers = take!(inPort1)

    # while input != "end"
    #     add(numbers, input)
    #     numberOfInputs += 1
    #     input = take!(inPort1)
    # end

    mean = Statistict.mean(numbers)

    put!(outPort1, mean)
end