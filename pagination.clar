;;;; Data variable definitions

(define-data-var activeDataIds (list 2500 uint) (list ))

;;;; Map definitions

(define-map Data
    uint
    {
        valueOne: uint,
        valueTwo: uint,
    }
)

;;;; Private function definitions

(define-private (get-data (id uint))
    (map-get? Data id)
)

(define-private (uint-list-slice (uintList (list 2500 uint)) (start uint))
    (get accumulator (fold uint-list-slice-iterator uintList {accumulator: (list ), index: u0, start: start}))
)

(define-private (uint-list-slice-iterator (value uint) (state {accumulator: (list 10 uint), index: uint, start: uint}))
    (let
        (
            (start
                (get start state)
            )
            (index
                (get index state)
            )
            (accumulator
                (get accumulator state)
            )
        )
        {
            start:
                start,
            accumulator:
                (if (>= index start)
                    (unwrap! (as-max-len? (append accumulator value) u10) state)
                    accumulator
                ),
            index:
                (+ index u1)
        }
    )
)

(define-read-only (get-active-data (start uint))
    (map get-data (uint-list-slice (var-get activeDataIds) start))
)
