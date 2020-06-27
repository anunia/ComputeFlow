"""
# module ToUpercase

- Julia version:
- Author: anunia
- Date: 2020-04-26

# Examples

```jldoctest
julia>
```
"""


using JSON

struct Options_ToUppercase
    all_text::Bool
    just_first_letters::Bool
    from_the_begging::Bool
    fb_amount_of_char::Int64
    from_the_end::Bool
    fe_amount_of_char::Int64
    Options_ToUppercase(all_text, just_first_letters, from_the_begging, fb_amount_of_char, from_the_end, fe_amount_of_char) =
        new(all_text, just_first_letters, from_the_begging, fb_amount_of_char, from_the_end, fe_amount_of_char)
end


function set_options_ToUppercase(variables)
    all_text = get(variables,"all_text",missing)
    just_first_letters = get(variables,"just_first_letters",missing)
    from_the_begging = get(variables,"from_the_begging",missing)
    fb_amount_of_char = get(variables,"fb_amount_of_char",missing)
    from_the_end = get(variables,"from_the_end",missing)
    fe_amount_of_char = get(variables,"fe_amount_of_char",missing)

    Options_ToUppercase(all_text, just_first_letters, from_the_begging, fb_amount_of_char, from_the_end, fe_amount_of_char)
end
function all_text_ToUppercase(text)
    uppercase(text)
end
function just_first_letters_ToUppercase(text)
    result = ""
    words = split(text, " ")
    for word in words
        if word != "" && word[1]>='a' && word[1]<='z'
            word[1] += "A" - "a"
            result *= word
        end
    end
    return result
end
function from_the_begging_ToUppercase(text, amount)
    result = ""
    if length(text) <= amount
        result = all_text(text)
    else
        i=1
        for c in text
            d=(uppercase("$c"))
            if amount > i
                result = result * d
            else
                result = result * "$c"
            end
            i = i + 1
        end
    end

    return result
end
function from_the_end_ToUppercase(text, amount)
    textlength = length(text)
    result = ""
    if textlength <= amount
        result = all_text(text)
    else
        i=1
        for c in text
            d=(uppercase("$c"))
            if textlength - amount < i
                result = result * d
            else
                result = result * "$c"
            end
            i = i + 1
        end
    end
    return result
end
function get_text(channel)
    txt = take!(channel)
    return txt
end
################# PROGRAM #################
function ToUppercase_f(inPort1, outPort1, variables)
    println(variables)
    options = set_options_ToUppercase(variables)

    text = get_text(inPort1)

    if options.all_text
        text = all_text_ToUppercase(text)
    else
        if options.just_first_letters
            text = just_first_letters_ToUppercase(text)
        end
        if options.from_the_begging
            text = from_the_begging_ToUppercase(text,options.fb_amount_of_char)
        end
        if options.from_the_end
            text = from_the_end_ToUppercase(text, options.fe_amount_of_char)
        end
    end
    put!(outPort1, text)
end

###################
############################################
#   Main function of the module
function FileReader_f(outPort1, variables)

    fileName = get(variables,"file_name",missing)

    text = read(fileName, String)

    put!(outPort1,text)
end

###################
############################################
#   MUTABLE part of module schema.
function WriteToFile_f(inPort1, variables)
    text = take!(inPort1)

    fileName = get(variables,"file_name",missing)

    open(fileName, "w") do f
        write(f, string(text))
    end
end

###################
function ToUppercase_test_f()
	ToUppercase_1_0 = Channel{String}(1)

	FileReader_2_0 = Channel{String}(1)

	 @async Task(ToUppercase_f(FileReader_2_0,ToUppercase_1_0,Dict{String,Any}("from_the_begging" => true,"just_first_letters" => false,"all_text" => false,"fe_amount_of_char" => 15,"from_the_end" => true,"fb_amount_of_char" => 10)))

	 @async Task(FileReader_f(FileReader_2_0,Dict{String,Any}("file_name" => "test.txt")))

	 @async Task(WriteToFile_f(ToUppercase_1_0,Dict{String,Any}("file_name" => "ToUpercase_result.txt")))


end
 ToUppercase_test_f()
