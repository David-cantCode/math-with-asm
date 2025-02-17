
section .bss
  input resb 10
  num1 resb 10
  num2 resb 10
  ans resb 20
  number resb 20
  
section .data
  intro db "Welcome to the calculator", 0xa
  introlen equ $ - intro
  op1 db "(1) adding", 0xa
  op1len equ $ - op1
  op2 db "(2) subtraction", 0xa
  op2len equ $ - op2
  op3 db "(3) dividing", 0xa
  op3len equ $ - op3
  op4 db "(4) multiplying ", 0xa
  op4len equ $ - op4


  choice db "whats your choice: ", 0xa
  choicelen equ $ - choice

  result dq 0 


  c1 db "welcome to adding!", 0xa
  c1len equ $ - c1

  c2 db "welcome to subtracting", 0xa
  c2len equ $ - c2

  c3 db "welcome to dividing", 0xa
  c3len equ $- c3

  c4 db "welcome to multiplying", 0xa
  c4len equ $- c4

  enum1 db "what is the first number? ", 0xa
  enum1len equ $- enum1 

  enum2 db "what is the second number? ", 0xa
  enum2len equ $- enum2




section .text
  global _start


_start:



text:
  mov rax, 1
  mov rdi, 1 
  mov rsi, intro
  mov rdx, introlen 
  syscall


  mov rax, 1
  mov rdi, 1
  mov rsi, op1
  mov rdx, op1len
  syscall

  mov rax, 1
  mov rdi, 1
  mov rsi, op2 
  mov rdx, op2len 
  syscall 
  
  mov rax, 1
  mov rdi, 1
  mov rsi, op3
  mov rdx, op3len
  syscall

  mov rax, 1
  mov rdi, 1
  mov rsi, op4 
  mov rdx, op4len 
  syscall


  mov rax, 1
  mov rdi, 1
  mov rsi, choice
  mov rdx, choicelen
  syscall


  mov rax, 0
  mov rdi, 0
  mov rsi, input
  mov rdx, 10
  syscall




  
choice_loop:
  mov rax, [input]

  cmp rax, "1"
  je add

  cmp rax, "2"
  je subtract

  cmp rax, '3'
  je dividing

  cmp rax, '4'
  je multiply

  jmp exit




  


add: 
  mov rax, 1
  mov rdi, 1
  mov rsi, c1
  mov rdx, c1len
  syscall



  mov rax, 1
  mov rdi, 1
  mov rsi, enum1
  mov rdx, enum1len 
  syscall

  mov rax, 0
  mov rdi, 0
  mov rsi, num1
  mov rdx, 10
  syscall



  ;change to int 
  mov rax, num1 
  call to_string
  
  mov rax, [number]
  mov [num1], rax



  mov rax, 1
  mov rdi, 1
  mov rsi, enum2
  mov rdx, enum2len
  syscall

  mov rax, 0
  mov rdi, 0
  mov rsi, num2
  mov rdx, 10
  syscall


  ;actually add

  mov rax, num1
  mov rsi, num2

  add rax, rsi

  call to_int 
  mov [ans], rax
  
  ;print output



  mov rax, 1
  mov rdi, 1
  mov rsi, ans
  mov rdx, 20
  syscall







subtract:
  mov rax, 1
  mov rdi, 1
  mov rdi, c2
  mov rdx, c2len
  syscall


dividing: 
  mov rax, 1
  mov rdi, 1
  mov rsi, c3
  mov rdx, c3len
  syscall

multiply:
  mov rax, 1
  mov rdi, 1
  mov rsi, c4
  mov rdx, c4len
  syscall






exit:
  mov rax, 60
  mov rdi, 1
  syscall



to_int:
    xor rax, rax          ; Clear rax to accumulate the result

.next_char:
    movzx rbx, byte [rsi] ; Load the next character from the string
    test rbx, rbx         ; Check if it's the null terminator
    jz .done              ; If yes, we're done

    sub rbx, '0'          ; Convert ASCII to integer (0-9)
    cmp rbx, 0            ; Check if it's less than '0'
    jb .done              ; If less than '0', exit (invalid)
    cmp rbx, 9            ; Check if it's greater than '9'
    ja .done              ; If greater than '9', exit (invalid)

    ; Accumulate the result
    mov rdx, rax          ; Save the old value
    shl rax, 1            ; rax = rax * 2
    shl rax, 1            ; rax = rax * 2 (4)
    add rax, rdx          ; rax = rax * 4 + old value (5 times)
    shl rax, 1            ; rax = rax * 10
    add rax, rbx          ; Add the new digit

    inc rsi               ; Move to the next character
    jmp .next_char        ; Repeat for the next character

.done:
    ret                    ; Return to the caller




to_string:
    push rax              ; Save rax
    push rsi              ; Save rsi

    mov rcx, 0            ; Digit count
    mov rbx, 10           ; Divisor for decimal
    xor rdx, rdx          ; Clear rdx for division

get_divisor:
    test rax, rax         ; Check if rax is zero
    jz _after              ; If zero, jump to after
    xor rdx, rdx          ; Clear rdx
    div rbx                ; Divide rax by 10
    push rdx              ; Save the remainder (digit)
    inc rcx               ; Increment digit count
    jmp get_divisor       ; Repeat for next digit

_after:
    mov rsi, number       ; Reset rsi to the start of the buffer
    ; Pop the digits off the stack and store them in reverse order
store_digits:
    test rcx, rcx         ; Check if we have digits left
    jz done               ; If not, we're done
    pop rdx               ; Get the last digit
    add dl, '0'           ; Convert to ASCII
    mov [rsi], dl         ; Store in buffer
    inc rsi               ; Move to next position
    dec rcx               ; Decrement digit count
    jmp store_digits      ; Repeat for the next digit

done:
    mov byte [rsi], 0     ; Null-terminate the string
    pop rsi               ; Restore rsi
    pop rax               ; Restore rax
    ret