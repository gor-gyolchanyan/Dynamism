//
// This is free and unencumbered software released into the public domain.
//
// Anyone is free to copy, modify, publish, use, compile, sell, or
// distribute this software, either in source code form or as a compiled
// binary, for any purpose, commercial or non-commercial, and by any
// means.
//
// In jurisdictions that recognize copyright laws, the author or authors
// of this software dedicate any and all copyright interest in the
// software to the public domain. We make this dedication for the benefit
// of the public at large and to the detriment of our heirs and
// successors. We intend this dedication to be an overt act of
// relinquishment in perpetuity of all present and future rights to this
// software under copyright law.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
// OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
// ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//
// For more information, please refer to <http://unlicense.org/>
//  

// MARK: - DynamicType (Hierarchy)

public extension DynamicType {

	/// Creates a dynamic type which `instance` is an instance of.
	@inlinable
	init(of instance: Any) {
		self.init(type(of: instance))
	}

	/// The type which `self` is an instance of.
	var metatype: DynamicType {
		@inlinable
		get {
			return DynamicType(type(of: self.native))
		}
	}

	/// The *conformance metatype*, if `self` is a protocol and its conformance metatype has been analyzed.
	///
	/// Given a protocol P, its *conformance metatype* is the type `P.Type`, which is the metattype of all concrete types that conform to `P` as opposed to `P.Protocol`, which is the metattype of `P` itself.
	/// Detailed explanation is available at [https://stackoverflow.com/a/45239416](https://stackoverflow.com/a/45239416).
	/// - note: The conformance metatype will only be available if it has been analyzed directly, since acquiring the metatype of a protocol from a generic context will never yield its conformance metatype.
	var protocolConformanceMetatype: DynamicType? {
		@inlinable
		get {
			guard
				let protocolMetatype = DynamicType("\(self.longName).Type"),
				protocolMetatype != metatype
				else {
					return nil
			}
			return protocolMetatype
		}
	}

	/// Whether or not instances of `self` are also types.
	var isMetatype: Bool {
		@inlinable
		get {
			let parts = self.longName.split(separator: ".")
			guard parts.count > 2 else {
				return false
			}
			let suffix = parts.last!
			return suffix == "Type" || suffix == "Protocol"
		}
	}

	/// Whether or not `self` is a protocol type.
	///
	/// - note: Refer to `self.protocolConformanceMetatype` for details and caveats.
	var isProtocol: Bool {
		@inlinable
		get {
			return self.protocolConformanceMetatype != nil
		}
	}

	/// Whether or not `self` is a class type.
	var isClass: Bool {
		@inlinable
		get {
			return self.native is AnyClass
		}
	}

	/// Determines whether `instance` is a direct or indirect instance of `self`.
	///
	/// - precondition: `self.isAnalyzed == true`
	@inlinable
	func isType(of instance: Any) -> Bool {
		return self.analysis.isTypeOf(instance)
	}

	/// Determines whether `self` is *supertype* of `other`.
	///
	/// Given types `A` and `B`, `A` is a *supertype* of `B` if and only if all instance of `B` are also instances of `A`.
	/// - precondition: `self.isAnalyzed == true`
	@inlinable
	func isSupertype(of other: DynamicType) -> Bool {
		return self.metatype.isType(of: other.native) || self.protocolConformanceMetatype?.isType(of: other.native) ?? false
	}

	/// Determines whether or not `self` is a supertype of `other`, but is not the same type as `other`.
	///
	/// - precondition: `self.isAnalyzed == true`
	@inlinable
	func isStrictSupertype(of other: DynamicType) -> Bool {
		return self.isSupertype(of: other) && self != other
	}

	/// Determines whether `self` is a *subtype* of `other`.
	///
	/// Given types `A` and `B`, `A` is a *subtype* of `B` if and only if all instance of `A` are also instances of `B`.
	/// - precondition: `self.isAnalyzed == true`
	@inlinable
	func isSubtype(of other: DynamicType) -> Bool {
		return other.isSupertype(of: self)
	}

	/// Determines whether or not `self` is a subtype of `other`, but is not the same type as `other`.
	///
	/// - precondition: `self.isAnalyzed == true`
	@inlinable
	func isStrictSubtype(of other: DynamicType) -> Bool {
		return self.isSubtype(of: other) && self != other
	}

}
