export interface IPrestashopDiscountCodeInsert {
  cart_rule: {
    name: {
      language: {
        _id: number;
        value: string;
      };
    };
    description: string;
    code: string;
    active: number;
    quantity: number;
    quantity_per_user: number;
    date_from: string;
    date_to: string;
  };
}
