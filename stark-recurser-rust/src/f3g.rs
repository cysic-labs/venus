//! Goldilocks cubic extension field (F3g).
//!
//! Elements are triples `[a, b, c]` representing `a + b*x + c*x^2` in
//! `GF(p^3)` where `p = 2^64 - 2^32 + 1` (Goldilocks prime) and the
//! irreducible polynomial is `x^3 - x - 1`.

use fields::{Field, Goldilocks, PrimeField64, QuotientMap};
use std::fmt;

/// The Goldilocks prime `p = 2^64 - 2^32 + 1`.
const P: u64 = 0xFFFF_FFFF_0000_0001;

/// A cubic extension field element over Goldilocks.
///
/// Internally stored as three `Goldilocks` base-field elements `[a, b, c]`
/// representing the polynomial `a + b*x + c*x^2` reduced modulo `x^3 - x - 1`.
#[derive(Copy, Clone, Debug, PartialEq, Eq)]
pub struct F3gElem {
    pub v: [Goldilocks; 3],
}

impl F3gElem {
    /// The additive identity.
    pub const ZERO: Self = Self { v: [Goldilocks::ZERO, Goldilocks::ZERO, Goldilocks::ZERO] };

    /// The multiplicative identity.
    pub const ONE: Self = Self { v: [Goldilocks::ONE, Goldilocks::ZERO, Goldilocks::ZERO] };

    /// Construct from three base-field elements.
    #[inline]
    pub fn new(a: Goldilocks, b: Goldilocks, c: Goldilocks) -> Self {
        Self { v: [a, b, c] }
    }

    /// Construct from three raw u64 values (each reduced mod p).
    #[inline]
    pub fn from_u64(a: u64, b: u64, c: u64) -> Self {
        Self::new(
            Goldilocks::from_int(a),
            Goldilocks::from_int(b),
            Goldilocks::from_int(c),
        )
    }

    /// Construct a "scalar" extension element `[v, 0, 0]`.
    #[inline]
    pub fn from_scalar(v: Goldilocks) -> Self {
        Self::new(v, Goldilocks::ZERO, Goldilocks::ZERO)
    }

    /// Construct a scalar from a raw u64 value.
    #[inline]
    pub fn from_scalar_u64(v: u64) -> Self {
        Self::from_scalar(Goldilocks::from_int(v))
    }

    /// Test whether this element is zero.
    #[inline]
    pub fn is_zero(&self) -> bool {
        self.v[0].is_zero() && self.v[1].is_zero() && self.v[2].is_zero()
    }

    /// Negation.
    #[inline]
    pub fn neg(&self) -> Self {
        Self::new(-self.v[0], -self.v[1], -self.v[2])
    }

    /// Addition.
    #[inline]
    pub fn add(&self, rhs: &Self) -> Self {
        Self::new(
            self.v[0] + rhs.v[0],
            self.v[1] + rhs.v[1],
            self.v[2] + rhs.v[2],
        )
    }

    /// Subtraction.
    #[inline]
    pub fn sub(&self, rhs: &Self) -> Self {
        Self::new(
            self.v[0] - rhs.v[0],
            self.v[1] - rhs.v[1],
            self.v[2] - rhs.v[2],
        )
    }

    /// Multiplication using Karatsuba-style formula.
    ///
    /// Given `a = (a0, a1, a2)` and `b = (b0, b1, b2)`, the product modulo
    /// `x^3 - x - 1` is computed as:
    ///
    /// ```text
    /// A = (a0+a1)*(b0+b1),  B = (a0+a2)*(b0+b2),  C = (a1+a2)*(b1+b2)
    /// D = a0*b0,  E = a1*b1,  F = a2*b2,  G = D - E
    /// result = [ C+G-F,  A+C-2E-D,  B-G ]
    /// ```
    #[inline]
    pub fn mul(&self, rhs: &Self) -> Self {
        let a = &self.v;
        let b = &rhs.v;

        let big_a = (a[0] + a[1]) * (b[0] + b[1]);
        let big_b = (a[0] + a[2]) * (b[0] + b[2]);
        let big_c = (a[1] + a[2]) * (b[1] + b[2]);
        let d = a[0] * b[0];
        let e = a[1] * b[1];
        let f = a[2] * b[2];
        let g = d - e;

        Self::new(
            big_c + g - f,
            big_a + big_c - e - e - d,
            big_b - g,
        )
    }

    /// Squaring, slightly more efficient than `self.mul(self)`.
    #[inline]
    pub fn square(&self) -> Self {
        let a = &self.v;

        let big_a = (a[0] + a[1]) * (a[0] + a[1]);
        let big_b = (a[0] + a[2]) * (a[0] + a[2]);
        let big_c = (a[1] + a[2]) * (a[1] + a[2]);
        let d = a[0] * a[0];
        let e = a[1] * a[1];
        let f = a[2] * a[2];
        let g = d - e;

        Self::new(
            big_c + g - f,
            big_a + big_c - e - e - d,
            big_b - g,
        )
    }

    /// Multiply by a base-field scalar.
    #[inline]
    pub fn mul_scalar(&self, s: Goldilocks) -> Self {
        Self::new(self.v[0] * s, self.v[1] * s, self.v[2] * s)
    }

    /// Multiply by a u64 scalar (reduced mod p).
    #[inline]
    pub fn mul_scalar_u64(&self, s: u64) -> Self {
        self.mul_scalar(Goldilocks::from_int(s))
    }

    /// Field inverse.
    ///
    /// For a pure scalar `[v, 0, 0]` this delegates to the base-field inverse.
    /// For a general cubic element, the norm-based inversion formula is used
    /// (matching the JS `inv` implementation).
    ///
    /// Panics on zero input.
    pub fn inv(&self) -> Self {
        // Check for scalar case
        if self.v[1].is_zero() && self.v[2].is_zero() {
            let inv_v = self.v[0].inverse();
            return Self::from_scalar(inv_v);
        }

        let a = self.v;
        let aa = a[0] * a[0];
        let ac = a[0] * a[2];
        let ba = a[1] * a[0];
        let bb = a[1] * a[1];
        let bc = a[1] * a[2];
        let cc = a[2] * a[2];

        let aaa = aa * a[0];
        let aac = aa * a[2];
        let abc = ba * a[2];
        let abb = ba * a[1];
        let acc = ac * a[2];
        let bbb = bb * a[1];
        let bcc = bc * a[2];
        let ccc = cc * a[2];

        // t = -aaa - 2*aac + 3*abc + abb - acc - bbb + bcc - ccc
        let t = abc + abc + abc + abb - aaa - aac - aac - acc - bbb + bcc - ccc;

        let tinv = t.inverse();

        let i0 = (bc + bb - aa - ac - ac - cc) * tinv;
        let i1 = (ba - cc) * tinv;
        let i2 = (ac + cc - bb) * tinv;

        Self::new(i0, i1, i2)
    }

    /// Division: `self / rhs`.
    #[inline]
    pub fn div(&self, rhs: &Self) -> Self {
        self.mul(&rhs.inv())
    }

    /// Exponentiation by a u64 exponent using square-and-multiply.
    pub fn exp(&self, mut e: u64) -> Self {
        if e == 0 {
            return Self::ONE;
        }

        let mut result = Self::ONE;
        let mut base = *self;

        while e > 0 {
            if e & 1 == 1 {
                result = result.mul(&base);
            }
            base = base.square();
            e >>= 1;
        }

        result
    }

    /// Convert to an array of three u64 values (canonical representations).
    pub fn to_u64_array(&self) -> [u64; 3] {
        [
            self.v[0].as_canonical_u64(),
            self.v[1].as_canonical_u64(),
            self.v[2].as_canonical_u64(),
        ]
    }

    /// String representation as `"[a, b, c]"` with decimal values.
    pub fn to_string_array(&self) -> [String; 3] {
        let vals = self.to_u64_array();
        [vals[0].to_string(), vals[1].to_string(), vals[2].to_string()]
    }
}

impl fmt::Display for F3gElem {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        let vals = self.to_u64_array();
        write!(f, "[{}, {}, {}]", vals[0], vals[1], vals[2])
    }
}

/// The F3g "field context" object, mirroring the JS `F3g` class.
///
/// Holds precomputed constants (shift, shift inverse, etc.) and provides
/// the same method signatures the JS callers expect.
pub struct F3g {
    pub p: u64,
    pub n8: usize,
    pub m: usize,
    pub shift: Goldilocks,
    pub shift_inv: Goldilocks,
}

impl Default for F3g {
    fn default() -> Self {
        Self::new()
    }
}

impl F3g {
    pub fn new() -> Self {
        let shift = Goldilocks::new(7);
        let shift_inv = shift.inverse();
        Self {
            p: P,
            n8: 8,
            m: 3,
            shift,
            shift_inv,
        }
    }

    /// Additive identity.
    #[inline]
    pub fn zero(&self) -> F3gElem {
        F3gElem::ZERO
    }

    /// Multiplicative identity.
    #[inline]
    pub fn one(&self) -> F3gElem {
        F3gElem::ONE
    }

    /// Construct an element from up to three u64 values.
    #[inline]
    pub fn e(&self, a: u64, b: u64, c: u64) -> F3gElem {
        F3gElem::from_u64(a, b, c)
    }

    /// Add two elements.
    #[inline]
    pub fn add(&self, a: &F3gElem, b: &F3gElem) -> F3gElem {
        a.add(b)
    }

    /// Subtract two elements.
    #[inline]
    pub fn sub(&self, a: &F3gElem, b: &F3gElem) -> F3gElem {
        a.sub(b)
    }

    /// Multiply two elements.
    #[inline]
    pub fn mul(&self, a: &F3gElem, b: &F3gElem) -> F3gElem {
        a.mul(b)
    }

    /// Negate an element.
    #[inline]
    pub fn neg(&self, a: &F3gElem) -> F3gElem {
        a.neg()
    }

    /// Inverse of an element.
    #[inline]
    pub fn inv(&self, a: &F3gElem) -> F3gElem {
        a.inv()
    }

    /// Division.
    #[inline]
    pub fn div(&self, a: &F3gElem, b: &F3gElem) -> F3gElem {
        a.div(b)
    }

    /// Multiply by a base-field scalar.
    #[inline]
    pub fn mul_scalar(&self, a: &F3gElem, s: u64) -> F3gElem {
        a.mul_scalar_u64(s)
    }

    /// Exponentiation.
    #[inline]
    pub fn exp(&self, base: &F3gElem, e: u64) -> F3gElem {
        base.exp(e)
    }

    /// Test equality.
    #[inline]
    pub fn eq(&self, a: &F3gElem, b: &F3gElem) -> bool {
        *a == *b
    }

    /// Test if zero.
    #[inline]
    pub fn is_zero(&self, a: &F3gElem) -> bool {
        a.is_zero()
    }

    /// Read a base-field element from a little-endian byte slice at the given
    /// offset. Reads exactly 8 bytes (Goldilocks n8 = 8).
    pub fn from_rpr_le(&self, buf: &[u8], offset: usize) -> u64 {
        let bytes: [u8; 8] = buf[offset..offset + 8]
            .try_into()
            .expect("from_rpr_le: need 8 bytes");
        u64::from_le_bytes(bytes)
    }

    /// Batch inverse using Montgomery's trick.
    pub fn batch_inverse(&self, elems: &[F3gElem]) -> Vec<F3gElem> {
        if elems.is_empty() {
            return vec![];
        }

        let n = elems.len();
        let mut products = Vec::with_capacity(n);
        products.push(elems[0]);
        for i in 1..n {
            products.push(products[i - 1].mul(&elems[i]));
        }

        let mut z = products[n - 1].inv();
        let mut result = vec![F3gElem::ZERO; n];

        for i in (1..n).rev() {
            result[i] = z.mul(&products[i - 1]);
            z = z.mul(&elems[i]);
        }
        result[0] = z;

        result
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use rand::{Rng, RngExt};

    fn random_elem(rng: &mut impl Rng) -> F3gElem {
        let p = P;
        F3gElem::from_u64(
            rng.random::<u64>() % p,
            rng.random::<u64>() % p,
            rng.random::<u64>() % p,
        )
    }

    fn random_nonzero_elem(rng: &mut impl Rng) -> F3gElem {
        loop {
            let e = random_elem(rng);
            if !e.is_zero() {
                return e;
            }
        }
    }

    #[test]
    fn test_add_sub_identity() {
        let a = F3gElem::from_u64(3, 5, 7);
        let b = F3gElem::from_u64(11, 13, 17);
        let sum = a.add(&b);
        let diff = sum.sub(&b);
        assert_eq!(diff, a);
    }

    #[test]
    fn test_neg() {
        let a = F3gElem::from_u64(42, 99, 1);
        let neg_a = a.neg();
        let zero = a.add(&neg_a);
        assert!(zero.is_zero());
    }

    #[test]
    fn test_mul_identity() {
        let a = F3gElem::from_u64(3, 5, 7);
        let one = F3gElem::ONE;
        assert_eq!(a.mul(&one), a);
        assert_eq!(one.mul(&a), a);
    }

    #[test]
    fn test_mul_zero() {
        let a = F3gElem::from_u64(3, 5, 7);
        let zero = F3gElem::ZERO;
        assert!(a.mul(&zero).is_zero());
    }

    #[test]
    fn test_mul_inv_roundtrip() {
        let mut rng = rand::rng();
        for _ in 0..100 {
            let a = random_nonzero_elem(&mut rng);
            let a_inv = a.inv();
            let product = a.mul(&a_inv);
            assert_eq!(
                product,
                F3gElem::ONE,
                "a * inv(a) should be 1 for a = {}",
                a
            );
        }
    }

    #[test]
    fn test_scalar_inv_roundtrip() {
        let a = F3gElem::from_scalar_u64(42);
        let a_inv = a.inv();
        let product = a.mul(&a_inv);
        assert_eq!(product, F3gElem::ONE);
    }

    #[test]
    fn test_mul_commutativity() {
        let mut rng = rand::rng();
        for _ in 0..50 {
            let a = random_elem(&mut rng);
            let b = random_elem(&mut rng);
            assert_eq!(a.mul(&b), b.mul(&a));
        }
    }

    #[test]
    fn test_mul_associativity() {
        let mut rng = rand::rng();
        for _ in 0..50 {
            let a = random_elem(&mut rng);
            let b = random_elem(&mut rng);
            let c = random_elem(&mut rng);
            assert_eq!(a.mul(&b).mul(&c), a.mul(&b.mul(&c)));
        }
    }

    #[test]
    fn test_distributivity() {
        let mut rng = rand::rng();
        for _ in 0..50 {
            let a = random_elem(&mut rng);
            let b = random_elem(&mut rng);
            let c = random_elem(&mut rng);
            // a * (b + c) == a*b + a*c
            let lhs = a.mul(&b.add(&c));
            let rhs = a.mul(&b).add(&a.mul(&c));
            assert_eq!(lhs, rhs);
        }
    }

    #[test]
    fn test_exp() {
        let a = F3gElem::from_u64(3, 5, 7);
        assert_eq!(a.exp(0), F3gElem::ONE);
        assert_eq!(a.exp(1), a);
        assert_eq!(a.exp(2), a.square());
        assert_eq!(a.exp(3), a.square().mul(&a));
    }

    #[test]
    fn test_square_equals_mul_self() {
        let mut rng = rand::rng();
        for _ in 0..50 {
            let a = random_elem(&mut rng);
            assert_eq!(a.square(), a.mul(&a));
        }
    }

    #[test]
    fn test_mul_scalar() {
        let a = F3gElem::from_u64(10, 20, 30);
        let s = Goldilocks::from_int(5u64);
        let result = a.mul_scalar(s);
        assert_eq!(result, F3gElem::from_u64(50, 100, 150));
    }

    #[test]
    fn test_div() {
        let mut rng = rand::rng();
        for _ in 0..50 {
            let a = random_elem(&mut rng);
            let b = random_nonzero_elem(&mut rng);
            let c = a.div(&b);
            // c * b should equal a
            assert_eq!(c.mul(&b), a);
        }
    }

    #[test]
    fn test_batch_inverse() {
        let f3g = F3g::new();
        let mut rng = rand::rng();
        let elems: Vec<F3gElem> = (0..20).map(|_| random_nonzero_elem(&mut rng)).collect();
        let inverses = f3g.batch_inverse(&elems);
        for (a, a_inv) in elems.iter().zip(inverses.iter()) {
            assert_eq!(a.mul(a_inv), F3gElem::ONE);
        }
    }

    #[test]
    fn test_display() {
        let a = F3gElem::from_u64(1, 2, 3);
        let s = format!("{}", a);
        assert_eq!(s, "[1, 2, 3]");
    }

    #[test]
    fn test_f3g_context() {
        let f3g = F3g::new();
        assert_eq!(f3g.p, P);
        assert_eq!(f3g.n8, 8);
        assert_eq!(f3g.m, 3);

        // shift * shift_inv == 1
        let product = f3g.shift * f3g.shift_inv;
        assert_eq!(product, Goldilocks::ONE);
    }

    #[test]
    fn test_from_rpr_le() {
        let f3g = F3g::new();
        let val: u64 = 0x0123_4567_89AB_CDEF;
        let bytes = val.to_le_bytes();
        assert_eq!(f3g.from_rpr_le(&bytes, 0), val);
    }

    #[test]
    fn test_known_values() {
        // Verify against known JS results:
        // In the JS F3g: mul([2,3,4], [5,6,7])
        //
        // A = (2+3)*(5+6) = 5*11 = 55
        // B = (2+4)*(5+7) = 6*12 = 72
        // C = (3+4)*(6+7) = 7*13 = 91
        // D = 2*5 = 10
        // E = 3*6 = 18
        // F = 4*7 = 28
        // G = 10-18 = -8 (mod p = p-8)
        //
        // r0 = C+G-F = 91 + (p-8) - 28 = 91 - 8 - 28 + p = 55 + p = 55 (mod p)
        // r1 = A+C-2E-D = 55 + 91 - 36 - 10 = 100
        // r2 = B-G = 72 - (p-8) = 72 + 8 - p = 80 - p  (mod p) = 80 (since B-G=72-(-8)=80)
        let a = F3gElem::from_u64(2, 3, 4);
        let b = F3gElem::from_u64(5, 6, 7);
        let c = a.mul(&b);
        let vals = c.to_u64_array();
        assert_eq!(vals[0], 55);
        assert_eq!(vals[1], 100);
        assert_eq!(vals[2], 80);
    }
}
