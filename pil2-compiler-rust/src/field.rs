/// Goldilocks prime: 2^64 - 2^32 + 1
const GOLDILOCKS_PRIME: u64 = 0xFFFFFFFF00000001;

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct GoldilocksField(pub u64);

impl GoldilocksField {
    pub fn new(v: u64) -> Self {
        Self(v % GOLDILOCKS_PRIME)
    }

    pub fn from_i64(v: i64) -> Self {
        if v >= 0 {
            Self::new(v as u64)
        } else {
            Self(GOLDILOCKS_PRIME - ((-v) as u64 % GOLDILOCKS_PRIME))
        }
    }

    pub fn add(self, other: Self) -> Self {
        Self(((self.0 as u128 + other.0 as u128) % GOLDILOCKS_PRIME as u128) as u64)
    }

    pub fn sub(self, other: Self) -> Self {
        if self.0 >= other.0 {
            Self(self.0 - other.0)
        } else {
            Self(GOLDILOCKS_PRIME - other.0 + self.0)
        }
    }

    pub fn mul(self, other: Self) -> Self {
        Self(((self.0 as u128 * other.0 as u128) % GOLDILOCKS_PRIME as u128) as u64)
    }

    pub fn neg(self) -> Self {
        if self.0 == 0 {
            self
        } else {
            Self(GOLDILOCKS_PRIME - self.0)
        }
    }

    pub fn inv(self) -> Self {
        self.pow(GOLDILOCKS_PRIME - 2)
    }

    pub fn pow(self, mut exp: u64) -> Self {
        let mut base = self;
        let mut result = Self(1);
        while exp > 0 {
            if exp & 1 == 1 {
                result = result.mul(base);
            }
            base = base.mul(base);
            exp >>= 1;
        }
        result
    }

    pub fn is_zero(self) -> bool {
        self.0 == 0
    }

    pub fn zero() -> Self {
        Self(0)
    }

    pub fn one() -> Self {
        Self(1)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_basic_arithmetic() {
        let a = GoldilocksField::new(5);
        let b = GoldilocksField::new(3);

        assert_eq!(a.add(b), GoldilocksField::new(8));
        assert_eq!(a.sub(b), GoldilocksField::new(2));
        assert_eq!(a.mul(b), GoldilocksField::new(15));
    }

    #[test]
    fn test_zero_one() {
        let zero = GoldilocksField::zero();
        let one = GoldilocksField::one();

        assert!(zero.is_zero());
        assert!(!one.is_zero());
        assert_eq!(zero.add(one), one);
    }

    #[test]
    fn test_negation() {
        let a = GoldilocksField::new(42);
        let neg_a = a.neg();
        assert!(a.add(neg_a).is_zero());
        assert!(GoldilocksField::zero().neg().is_zero());
    }

    #[test]
    fn test_subtraction_underflow() {
        let a = GoldilocksField::new(3);
        let b = GoldilocksField::new(5);
        let result = a.sub(b);
        // 3 - 5 mod p = p - 2
        assert_eq!(result, GoldilocksField::new(GOLDILOCKS_PRIME - 2));
        // And adding 5 back should give 3
        assert_eq!(result.add(b), a);
    }

    #[test]
    fn test_inverse() {
        let a = GoldilocksField::new(7);
        let inv_a = a.inv();
        assert_eq!(a.mul(inv_a), GoldilocksField::one());
    }

    #[test]
    fn test_from_i64_negative() {
        let neg = GoldilocksField::from_i64(-1);
        assert_eq!(neg, GoldilocksField::new(GOLDILOCKS_PRIME - 1));
        assert!(neg.add(GoldilocksField::one()).is_zero());
    }

    #[test]
    fn test_pow() {
        let a = GoldilocksField::new(2);
        assert_eq!(a.pow(10), GoldilocksField::new(1024));
    }

    #[test]
    fn test_reduction() {
        // Values >= GOLDILOCKS_PRIME should be reduced
        let a = GoldilocksField::new(GOLDILOCKS_PRIME);
        assert!(a.is_zero());
        let b = GoldilocksField::new(GOLDILOCKS_PRIME + 1);
        assert_eq!(b, GoldilocksField::one());
    }
}
