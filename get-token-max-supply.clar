(define-private (get-token-max-supply)
  (match (var-get tokenMaxSupply)
    returnTokenMaxSupply returnTokenMaxSupply
    (let
      (
        (newTokenMaxSupply (unwrap! (contract-call? .reat-token get-max-supply) u0))
      )
      (var-set tokenMaxSupply (some newTokenMaxSupply))
      newTokenMaxSupply
    )
  )
)
