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
say reverse("hi")
say reverse("hello")
say reverse("rexx")

/* using a custom function */
say "hi    = " reverse_string("hi")
say "hello = " reverse_string("hello")
say "rexx  = " reverse_string("rexx")

exit 0

reverse_string: procedure
    parse arg word

    reversed_word = ''

    if word <> "" then do
        do i = 1 to length(word)
            reversed_word = substr(word, i, 1) || reversed_word
        end
    end

return reversed_word