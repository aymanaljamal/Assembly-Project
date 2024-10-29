.MODEL small
.STACK 100h

.DATA
input_Msg DB 'Please enter a number between 0 and 999: $'
binary_Msg DB 0DH, 0AH, '1- The number in binary format is: $'
hex_Msg DB 0DH, 0AH, '2- The number in hexadecimal format is: $'
roman_Msg DB 0DH, 0AH, '3- The number in Roman format is: $'
Msg DB 0DH, 0AH, '4- The number in 3 format is: $'
newline DB 0DH, 0AH, '$'
binary DB 17 DUP('$')
hex DB 5 DUP('$')
roman DB 20 DUP('$')
number DW 0
 3_num  DB 17 DUP('$') 
      
      
hundreds db "C", 0, "CC", 0, "CCC", 0, "CD", 0, "D", 0, "DC", 0, "DCC", 0, "DCCC", 0, "CM", 0
    tens db "X", 0, "XX", 0, "XXX", 0, "XL", 0, "L", 0, "LX", 0, "LXX", 0, "LXXX", 0, "XC", 0
    units db "I", 0, "II", 0, "III", 0, "IV", 0, "V", 0, "VI", 0, "VII", 0, "VIII", 0, "IX", 0
.CODE
START:
    mov ax, @data
    mov ds, ax
    mov es, ax

;--------------------------------
    mov ah, 09h
    lea dx, input_Msg
    int 21h

;--------------------------------   
    call read_three_digits

    call print_newline 
 ;--------------------------------
    call display_binary
   
    call print_newline
;--------------------------------
  
    call display_hex
   
    call print_newline
;--------------------------------
    
    call display_roman
   
    call print_newline
;--------------------------------  

    
    call convert_to_3
   
    call print_newline
;--------------------------------
   
    mov ah, 4Ch
    int 21h
;--------------------------------
read_three_digits:
    xor ax, ax          
    xor bx, bx           

  
    call read_digit
    push ax             

  
    call read_digit
    push ax           

   
    call read_digit
    push ax              

    
    pop ax               
    mov cx, 1          
    mul cx
    add bx, ax

    pop ax               
    mov cx, 10          
    mul cx
    add bx, ax

    pop ax               
    mov cx, 100          
    mul cx
    add bx, ax

    mov number, bx       
    ret


read_digit:
    mov ah, 01h        
    int 21h            
    and al, 0Fh          
    mov ah, 0            
    ret
    
;--------------------------------   
print_newline:
    mov ah, 09h
    lea dx, newline
    int 21h
    ret

;--------------------------------
display_binary:
    mov ah, 09h
    lea dx, binary_Msg
    int 21h

    call convert_to_binary

    mov ah, 09h
    lea dx, binary
    int 21h
    ret

convert_to_binary:
    mov ax, number     
    lea di, binary    
    mov cx, 16          

convert_binary_loop:
    shl ax, 1            
    jnc store_zero      
    mov byte ptr [di], '1'
    jmp store_bit
store_zero:
    mov byte ptr [di], '0'
store_bit:
    inc di               
    loop convert_binary_loop

    mov byte ptr [di], '$'  
    ret
  ;------------------------------------------

display_hex:
    mov ah, 09h
    lea dx, hex_Msg
    int 21h

    call convert_to_hex

    mov ah, 09h
    lea dx, hex
    int 21h
    ret

convert_to_hex:
    mov ax, number     
    lea di, hex     
    mov cx, 4            

convert_hex_loop:
    mov bx, ax           
    shr bx, 12         
    and bx, 0Fh        
    add bx, '0'          
    cmp bx, '9'
    jbe store_hex_digit
    add bx, 7            
store_hex_digit:
    mov [di], bl        
    inc di              
    shl ax, 4            
    loop convert_hex_loop

    mov byte ptr [di], '$'  
    ret

  ;---------------------------------


display_roman:
   
    mov ah, 09h
    lea dx, roman_Msg
    int 21h

    
    mov ax, number
    call convert_to_roman

   
    mov ah, 09h
    lea dx, roman
    int 21h
    ret

convert_to_roman:
    
    lea di, roman

  
    mov ax, number
    mov bx, 100
    xor dx, dx          
    div bx             
    cmp ax, 0           
    je skip_hundreds     
    mov si, offset hundreds
    call lodd_roman
skip_hundreds:
     
     
    mov ax, dx           
    mov bx, 10
    xor dx, dx          
    div bx              
    cmp ax, 0            
    je skip_tens         
    mov si, offset tens
    call lodd_roman
skip_tens:

    
    mov ax, dx          
    cmp ax, 0            
    je skip_units       
    mov si, offset units
    call lodd_roman
skip_units:

   
    mov byte ptr [di], '$'
    ret

lodd_roman:
   
    mov cx, ax           
    dec cx               

calculate_offset:
   
    cmp cx, 0
    je llod_loop         

    
    next_string:
    mov al, [si]
    inc si
    cmp al, 0
    jne next_string      
    dec cx              
    jmp calculate_offset

llod_loop:
   
llod_loop_put:
    mov al, [si]        
    cmp al, 0           
    je end_llod         
    mov [di], al         
    inc si               
    inc di               
    jmp llod_loop_put  

end_llod:
    ret  
    
    display_3:
    mov ah, 09h
    lea dx, Msg
    int 21h

    call convert_to_3

    mov ah, 09h
    lea dx, 3_num
    int 21h
    ret

convert_to_3:
    mov ax, number     
    lea di, 3_num    
           

convert_3_loop:
    mov bx ,3
    div bx
      cmp bx ,2
      je  store_2 
      cmp bx ,1
      je  store_1
      cmp bx ,0
      je  store_0
     store_0 :     
    mov byte ptr [di], '0'
    jmp store_bit3
    store_1:
    mov byte ptr [di], '1'
    store_2:
    mov byte ptr [di], '2'
     
    store_bit3: 

    inc di               
    cmp ax ,0
    jbe convert_3_loop 

    mov byte ptr [di], '$'  
    ret
END START