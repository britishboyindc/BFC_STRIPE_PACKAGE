{
  "id": "evt_1BBvoTH6IvMHn4WuMlRFVOHX",
  "object": "event",
  "api_version": "2017-04-06",
  "created": 1507772921,
  "data": {
    "object": {
      "id": "in_1BBvoSH6IvMHn4WusuFtnFpE",
      "object": "invoice",
      "amount_due": 2500,
      "application_fee": null,
      "attempt_count": 0,
      "attempted": true,
      "billing": "charge_automatically",
      "charge": "ch_1BBvoSH6IvMHn4WuiS9FQ6STT",
      "closed": true,
      "currency": "usd",
      "customer": "cus_BZ3w71tOAxM2tO",
      "date": 1507772920,
      "description": null,
      "discount": null,
      "ending_balance": 0,
      "forgiven": false,
      "lines": {
        "object": "list",
        "data": [
          {
            "id": "sub_BZ3wVMXJ7yZ4GF",
            "object": "line_item",
            "amount": 2500,
            "currency": "usd",
            "description": null,
            "discountable": true,
            "livemode": true,
            "metadata": {
              "Email": "peter.n.churchill@gmail.com"
            },
            "period": {
              "start": 1507772920,
              "end": 1510451320
            },
            "plan": {
              "id": "nursery25",
              "object": "plan",
              "amount": 2500,
              "created": 1500578852,
              "currency": "usd",
              "interval": "month",
              "interval_count": 1,
              "livemode": true,
              "metadata": {},
              "name": "The Nursery Project - $25",
              "statement_descriptor": null,
              "trial_period_days": null
            },
            "proration": false,
            "quantity": 1,
            "subscription": null,
            "subscription_item": "si_1BBvoSH6IvMHn4WuuLhn27TE",
            "type": "subscription"
          }
        ],
        "has_more": false,
        "total_count": 1,
        "url": "/v1/invoices/in_1BBvoSH6IvMHn4WusuFtnFpe/lines"
      },
      "livemode": true,
      "metadata": {},
      "next_payment_attempt": null,
      "number": "c778a2cc26-0001",
      "paid": true,
      "period_end": 1507772920,
      "period_start": 1507772920,
      "receipt_number": null,
      "starting_balance": 0,
      "statement_descriptor": null,
      "subscription": "sub_BZ3wVMXJ7yZ4GF",
      "subtotal": 2500,
      "tax": null,
      "tax_percent": null,
      "total": 2500,
      "webhooks_delivered_at": null
    }
  },
  "livemode": true,
  "pending_webhooks": 2,
  "request": "req_TynF7Q4SRsg53U",
  "type": "invoice.payment_succeeded"
}