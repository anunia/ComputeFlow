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

module ToUppercase
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


    function set_options_ToUppercase(options)
        options = JSON.parse(read(options,String))

        all_text = get(options,"all_text",missing)
        just_first_letters = get(options,"just_first_letters",missing)
        from_the_begging = get(options,"from_the_begging",missing)
        fb_amount_of_char = get(options,"fb_amount_of_char",missing)
        from_the_end = get(options,"from_the_end",missing)
        fe_amount_of_char = get(options,"fe_amount_of_char",missing)

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
    function ToUppercase_f(inputs_p, outputs_p, options)

        options = set_options_ToUppercase(options)

        text = get_text(inputs_p[1])

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
        put!(outputs_p[1], text)
    end
end