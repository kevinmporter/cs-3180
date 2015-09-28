; Kevin Porter
; CS-3180
; Project 1 (Racket)

; See commented-out call to "instructor's player" function

#lang racket

(define (string-contains? str sub)
  (regexp-match? (regexp sub) str))
(define (->string x)
  (call-with-output-string
   (lambda (out)
     (display x out))))
(define words_list (file->list "linuxwords.txt"))
(random-seed (current-seconds))
(define num_of_vowels(+ 7 (random 6)))
(define vowels_list '(#\A #\E #\I #\O #\U))
(define vowels (list->set vowels_list))

(define uppercase_letters_list (build-list 26 (lambda (x) (integer->char (+ x (char->integer #\A))))))
(define uppercase_letters (list->set uppercase_letters_list))

(define consonants (set-subtract uppercase_letters vowels))
(define consonants_list (set->list consonants))

(define num_of_consonants(- 25 num_of_vowels))
(define letters '())
(for ([i num_of_vowels])
  (set! letters (append letters (list (list-ref vowels_list (random 5)))))
  )

(for ([i num_of_consonants])
  (set! letters (append letters (list (list-ref consonants_list (random 20)))))
  )
(set! letters (shuffle letters))
(define letters_set (list->set letters))
(define (print_board line) 
  (printf "|---|---|---|---|---|\n|")
  (for-each (lambda (arg)
              (printf " ~a |" arg))
            line)
  (printf "\n")
  )
(define gameGrid '())
(for ([i 5])
  (let () (define idx_start (* i 5))
    (define line '())
    (define lst_line '())
    (for ([j 5])
      (set! line (append line (list (list-ref letters (+ idx_start j)))))
      (set! lst_line (append lst_line (list (string (list-ref letters (+ idx_start j))))))
      )
    (set! gameGrid (append gameGrid (list lst_line)))
    (print_board line)
    )
  )
(printf "|---|---|---|---|---|\n")

(printf "Enter as many words as possible, separated by spaces: \n")
(define input (string-split (string-upcase(read-line))))
(define (is_legal argv)
  (define test letters)
  (memf (lambda (argw)
          (set! test (remove argw test))
          (member argw test)
          )
        (string->list argv)
  )
  )
(define (is_word argv) (memf (lambda (argw)
                               (string-ci=? (->string argv) (->string argw))
                               )
                             words_list
                             )
  )
(define accepted_input '())
(define (is_legal_and_word argv) 
  (is_word argv) (and (is_legal argv)))
(for-each (lambda (argv) (when (is_legal_and_word argv)
                           (set! accepted_input (append accepted_input (list argv))))
            )
          input
          )
(define user_score 0)
(for-each (lambda (argv)
            (cond
              [(equal? (string-length argv) 4) (set! user_score (+ user_score 1)) (printf "~a\t~a\n" 1 argv)]
              [(equal? (string-length argv) 5) (set! user_score (+ user_score 2)) (printf "~a\t~a\n" 2 argv)]
              [(equal? (string-length argv) 6) (set! user_score (+ user_score 3)) (printf "~a\t~a\n" 3 argv)]
              [(equal? (string-length argv) 7) (set! user_score (+ user_score 5)) (printf "~a\t~a\n" 5 argv)]
              [(> (string-length argv) 7) (set! user_score (+ user_score 11)) (printf "~a\t~a\n" 11 argv)]
              )
            )
          accepted_input
          )
(printf "Total user score: ~a\n" user_score)

(define pattern (string-append "^[" (string-append (list->string letters) (string-append "]{4,}$"))))
(define computer_input '())
(define (is_legal_and_list lst)
  (list? lst) (and (is_legal (->string lst))))
(for-each (lambda (argv) (let ()
                           (define resp (regexp-match (pregexp pattern) (string-upcase (->string argv))))
                           (cond
                             [(not (equal? (is_legal_and_list argv) #f)) (if (equal? resp #f) (+ 1 0) (set! computer_input (append computer_input resp)))]                         
                           )))
          words_list
          )
(define computer_score 0)
(for-each (lambda (argv)
            (cond
              [(equal? (string-length argv) 4) (set! computer_score (+ computer_score 1)) (printf "~a\t~a\n" 1 argv)]
              [(equal? (string-length argv) 5) (set! computer_score (+ computer_score 2)) (printf "~a\t~a\n" 2 argv)]
              [(equal? (string-length argv) 6) (set! computer_score (+ computer_score 3)) (printf "~a\t~a\n" 3 argv)]
              [(equal? (string-length argv) 7) (set! computer_score (+ computer_score 5)) (printf "~a\t~a\n" 5 argv)]
              [(> (string-length argv) 7) (set! computer_score (+ computer_score 11)) (printf "~a\t~a\n" 11 argv)]
              )
            )
          computer_input
          )
(printf "Total computer score: ~a\n" computer_score)

;(define (instructors-player gameGrid) () )