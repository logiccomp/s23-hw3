#lang isl-spec

;; Problem 1: Encryption, perfect secrecy
;;
;; Your task is to define a property, `xor-perfect-prop`, that takes an
;; encrypted message and show that, for _any_ original message, there exists
;; some key that could have produced that encrypted message. You can show that
;; the key you discovered is valid by showing that it can be used to decrypt
;; the given encrypted message to produce the arbitrary message.

;; Once your property is defined, we can check that it holds by running it on
;; many different messages.

;; We've provided helper code to define Bits, Messages, xor, and encrypt/decrypt.

;; part p1a

; A Bit is one of:
; - 0
; - 1

(define Bit (qc:choose-one-of (list 0 1)))

; A Key is a (list Bit Bit Bit Bit Bit Bit)

(define Key (qc:choose-list Bit 6))

; A Message is a (list Bit Bit Bit Bit Bit Bit)

(define Message (qc:choose-list Bit 6))
;; part p1a

;; part p1b
; xor : Bit Bit -> Bit
(define (xor b1 b2)
  (modulo (+ b1 b2) 2))
(check-expect (xor 0 0) 0)
(check-expect (xor 0 1) 1)
(check-expect (xor 1 0) 1)
(check-expect (xor 1 1) 0)

; xor-list : [List-of Bit] [List-of Bit] -> [List-of Bit]
(define (xor-list l1 l2)
  (map xor l1 l2))
(check-expect (xor-list (list 1 0 0) (list 1 1 1)) (list 0 1 1))
(check-expect (xor-list (list 0 0 0) (list 0 0 0)) (list 0 0 0))

; encrypt : Message Key -> Message
(define encrypt xor-list)

; decrypt : Message Key -> Message
(define decrypt xor-list)
;; part p1b

;; part p1c
(define (xor-perfect-prop encr-msg) ...)

(check-property (for-all [(x Message)] (xor-perfect-prop x)))
;; part p1c

;; Problem 2:
;;
;; In this problem, you will write a correctness spec for a function that
;; should take a list of TaxRecords and a list of BuildingOwners, and
;; compute a list of OwnerAssets, merging differently named BuildingOwners
;; that share an address. The spec should capture properties that relate
;; the output of `find-landlords` (which you do not have to implement, though
;; are welcome to) with the inputs. Think about how to ensure that any
;; any implementation of `find-landlords` that satisfies your spec does
;; the right thing. 

;; part p2a
(define-struct tax-record [address value owner])
;; A TaxRecord is a (make-tax-record String Number String)

(define-struct building-owner [name address])
;; A BuildingOwner is a (make-building-owner String String)
;; Invariant: name is globally unique.

(define-struct owner-assets [names assets])
;; An OwnerAssets is a (make-owner-assets [List-of String] Number)

; find-landlords: [List-of TaxRecord] [List-of BuildingOwner] -> [List-of OwnerAssets]
; find mega-landlords by using the addresses of owners to merge ostensibly different landlords,
; totalling the assets for each unique address
(define (find-landlords tr bor) ...)
;; part p2a

;; part p2b
;; find-landlords-spec : [List-of TaxRecord] [List-of BuildingOwner] -> Boolean
(define (find-landlords-spec tr bor)
  ...)
;; part p2b


;; Problem 3
;;
;; In this problem, you first need to write a spec that captures the fact that
;; the timing of `check-password` does not vary based on the inputs.
;;
;; Since actual timing information has noise in it that requires collecting
;; many samples to deal with, we have a simplified model where we can start
;; a timer with (start-timer!), we can make the clock tick with (tick!), and
;; we can get the current count of the clock with (get-timer!).
;;
;; To do this problem, you _must_ use our provided `tick-string=?` if you want
;; to compare strings (you may not use equal?, string=?, or re-implement those
;; some other way). If you want to check the length of a list,
;; use `tick-length`.
;;
;; Using these, you can call `start-timer!` before a call to `check-password`,
;; and `get-timer!` after to compute how many ticks the call took. No matter
;; the password used, the number of ticks should be the same. You are welcome
;; to define your own functions that use `tick!`, if you need to balance out
;; the "time" (i.e., ticks) consumed by calls to `tick-string=?` or
;; `tick-length`.
;;
;; Once you do that, you should find that `check-password` is indeed leaking
;; timing information, so your second task is to fix `check-password`.

;; You may do it however you'd like, but, again, you may not use `string=?` or
;; `length` (or re-implement them); if you want either function, you must use
;; the provided `tick-` versions. 

;; part p3a

; tick-string=? : String String -> Bool
(define (tick-string=? s1 s2)
  (local [(define ticks (min (string-length s1)
                             (string-length s2)))
          (define _ (build-list ticks (λ(_) (tick!))))]
    (string=? s1 s2)))

; tick-length : (X) [List-of X] -> Number
(define (tick-length l)
  (local [(define _ (tick!))]
    (cond [(empty? l) 0]
          [(cons? l) (+ 1 (tick-length (rest l)))])))
;; part p3a

;; part p3b
; list=? : (X) [X -> Bool] [List-of X] [List-of X] -> Bool
(define (list=? elt=? l1 l2)
  (cond [(and (empty? l1) (empty? l2)) #t]
        [(and (empty? l1) (cons? l2)) #f]
        [(and (cons? l1) (empty? l2)) #f]
        [(and (cons? l1) (cons? l2))
         (and (elt=? (first l1) (first l2))
              (list=? elt=? (rest l1) (rest l2)))]))

(define PASSWORD (explode "a7he29hdee"))

; check-password : [List-of String] -> Bool
(define (check-password p)
  (list=? tick-string=? PASSWORD p))
;; part p3b

;; part p3c
(define (timing-spec p1 p2)
  ...)

(check-property (for-all [(p1 String)
                          (p2 String)]
                  (timing-spec p1 p2)))
;; part p3c

