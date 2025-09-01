/* REXX */

/*****************************************************************************/
/* Directions:                                                               */
/* Given an integer, return an integer that is the reverse ordering of       */
/* the number.                                                               */
/*                                                                           */
/* Examples:                                                                 */
/* reverse_num(15) === 51                                                    */
/* reverse_num(981) === 189                                                  */
/* reverse_num(500) === 005                                                  */
/* reverse_num(-15) === -51                                                  */
/* reverse_num(-90) === -9                                                   */
/*****************************************************************************/

say "reverse_num(15)  = " reverse_num(-15)
say "reverse_num(981) = " reverse_num(981)
say "reverse_num(500) = " reverse_num(500)
say "reverse_num(-15) = " reverse_num(-15)
say "reverse_num(-90) = " reverse_num(-90)

/* native */
say "reverse(15)  = " reverse(-15)
say "reverse(981) = " reverse(981)
say "reverse(500) = " reverse(500)
say "reverse(-15) = " reverse(-15)
say "reverse(-90) = " reverse(-90)

exit 0

reverse_num: procedure
  parse arg n
  reversed = ''
  
  /* Get the absolute value of n for reversing */
  abs_n = abs(n)

  /* Convert the absolute number to a string and reverse it */
  do i = length(abs_n) to 1 by -1
    reversed = reversed || substr(abs_n, i, 1)
  end

  /* Convert the reversed string back to an integer */
  result = value(reversed)

  /* Adjust the sign based on the original number */
  if n < 0 then
    result = result || "-"

return result