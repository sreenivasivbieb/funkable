;; Define the fungible token
(define-fungible-token simple-token)

;; Constants
(define-constant contract-owner tx-sender)
(define-constant token-name "Simple Token")
(define-constant token-symbol "STK")
(define-constant token-decimals u18)

;; Error codesclarinet c
(define-constant err-owner-only (err u100))
(define-constant err-insufficient-balance (err u101))
(define-constant err-invalid-amount (err u102))

;; Token Information Functions
(define-read-only (get-name)
    (ok token-name)
)

(define-read-only (get-symbol)
    (ok token-symbol)
)

(define-read-only (get-decimals)
    (ok token-decimals)
)

;; Get balance of an account
(define-read-only (get-balance (account principal))
    (ok (ft-get-balance simple-token account))
)

;; Get total supply
(define-read-only (get-total-supply)
    (ok (ft-get-supply simple-token))
)

;; Transfer tokens from sender to recipient
(define-public (transfer (amount uint) (recipient principal))
    (begin
        ;; Check if amount is valid
        (asserts! (> amount u0) err-invalid-amount)
        ;; Check if sender has sufficient balance
        (asserts! (>= (ft-get-balance simple-token tx-sender) amount) err-insufficient-balance)
        ;; Transfer the tokens
        (try! (ft-transfer? simple-token amount tx-sender recipient))
        ;; Print transfer event
        (print {
            event: "transfer",
            from: tx-sender,
            to: recipient,
            amount: amount
        })
        (ok true)
    )
)

;; Transfer from one account to another (requires approval - simplified version)
(define-public (transfer-from (amount uint) (sender principal) (recipient principal))
    (begin
        ;; Only allow self-transfers or owner transfers for simplicity
        (asserts! (or (is-eq tx-sender sender) (is-eq tx-sender contract-owner)) err-owner-only)
        ;; Check if amount is valid
        (asserts! (> amount u0) err-invalid-amount)
        ;; Check if sender has sufficient balance
        (asserts! (>= (ft-get-balance simple-token sender) amount) err-insufficient-balance)
        ;; Transfer the tokens
        (try! (ft-transfer? simple-token amount sender recipient))
        ;; Print transfer event
        (print {
            event: "transfer-from",
            from: sender,
            to: recipient,
            amount: amount,
            caller: tx-sender
        })
        (ok true)
    )
)

;; Mint new tokens (only contract owner)
(define-public (mint (amount uint) (recipient principal))
    (begin
        ;; Only contract owner can mint
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)
        ;; Check if amount is valid
        (asserts! (> amount u0) err-invalid-amount)
        ;; Mint the tokens
        (try! (ft-mint? simple-token amount recipient))
        ;; Print mint event
        (print {
            event: "mint",
            to: recipient,
            amount: amount,
            new-supply: (ft-get-supply simple-token)
        })
        (ok true)
    )
)

;; Burn tokens from caller's account
(define-public (burn (amount uint))
    (begin
        ;; Check if amount is valid
        (asserts! (> amount u0) err-invalid-amount)
        ;; Check if sender has sufficient balance
        (asserts! (>= (ft-get-balance simple-token tx-sender) amount) err-insufficient-balance)
        ;; Burn the tokens
        (try! (ft-burn? simple-token amount tx-sender))
        ;; Print burn event
        (print {
            event: "burn",
            from: tx-sender,
            amount: amount,
            new-supply: (ft-get-supply simple-token)
        })
        (ok true)
    )
)

;; Get contract owner
(define-read-only (get-owner)
    (ok contract-owner)
)

;; Initialize contract with initial supply to owner
(define-private (initialize)
    (begin
        (try! (ft-mint? simple-token u1000000000000000000000000 contract-owner)) ;; 1M tokens with 18 decimals
        (ok true)
    )
)

;; Call initialize on contract deployment
(initialize)