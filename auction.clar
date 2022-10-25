
(define-map Auction
    uint
    {
        id: uint,
        assetId: uint,
        reserveAmount: uint,
        lastBidAmount: uint,
        lastBidAccount: (optional principal),
        lastUpdateAt: uint,
        closeAt: (optional uint),
    }
)

(define-data-var lastFilterId uint u0)
(define-data-var activeAuctionIds (list 2000 uint) (list ))

(define-private (filter-list (id uint))
    (if (is-eq id (var-get lastFilterId)) false true)
)

(define-private (closeout-active-auction? (auctionId uint) (count uint))
    (if (is-some (map-get? Auction auctionId))
        (let
            (
                (auction
                    (unwrap-panic (map-get? Auction auctionId))
                )
                (auctionAssetId
                    (get id auction)
                )
                (auctionLastBidAccount
                    (get lastBidAccount auction)
                )
                (auctionCloseAt
                    (get closeAt auction)
                )
            )
            (if (is-some auctionCloseAt)
                (if (and (> block-height (unwrap-panic auctionCloseAt)) (is-some auctionLastBidAccount))
                    (if (not (is-eq (unwrap-panic auctionLastBidAccount) (as-contract tx-sender)))
                        (if (is-ok (as-contract (contract-call? .megapont-ape-club-nft transfer auctionAssetId tx-sender (unwrap-panic auctionLastBidAccount))))
                            (begin
                                (var-set lastFilterId auctionId)
                                (var-set activeAuctionIds (unwrap-panic (as-max-len? (filter filter-list (var-get activeAuctionIds)) u2000)))
                                (+ count u1)
                            )
                            count
                        )
                        count
                    )
                    count
                )
                count
            )
        )
        count
    )
)

(define-public (run-job)
    (ok (fold closeout-active-auction? (var-get activeAuctionIds) u0))
)
