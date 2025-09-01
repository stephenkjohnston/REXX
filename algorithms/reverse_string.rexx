/* REXX */

/*****************************************************************************/
/* Directions:                                                               */
/* Given a string, return a new string with the reversed order of characters */
/*                                                                           */
/* Examples:                                                                 */
/* hi    = ih                                                                */
/* hello = olleh                                                             */
/* rexx  = xxer                                                              */
/*****************************************************************************/

/* using the native function */
say "reverse("hi")    = " reverse("hi")
say "reverse("hello") = " reverse("hello")
say "reverse("rexx")  = " reverse("rexx")

/* using a custom function */
say "reverse_string(""hi"")    = " reverse_string("hi")
say "reverse_string(""hello"") = " reverse_string("hello")
say "reverse_string(""rexx"")  = " reverse_string("rexx")

exit 0

reverse_string: procedure
    parse arg word

    reversed_word = ''

    if word <> "" then do
        do i = 1 to length(word)
            character = substr(word, i, 1)
            if datatype(character, 'M') then do
                reversed_word = character || reversed_word
            end
        end
    end

return reversed_word