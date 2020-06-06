@testable import App
import XCTVapor
import Fluent

final class BlogCategoryApiTests: AppTestCase {
	func testGetCategories() throws {
		let app = try createTestApp()
		let token = try getAPIToken(app)
		defer { app.shutdown() }

		let headers = HTTPHeaders([("Authorization", "Bearer \(token)")])

		try app.testable(method: .inMemory)
			.test(.GET, "/api/blog/categories", headers: headers) { res in
				XCTAssertEqual(res.status, .ok)
				let contentType = try XCTUnwrap(res.headers.contentType)
				XCTAssertEqual(contentType, .json)
				XCTAssertContent(Page<BlogCategoryModel.ListItem>.self, res) { content in
					XCTAssertEqual(content.metadata.total, 2)
				}
		}
	}

	func testCreateCategory() throws {
		let app = try createTestApp()
		let token = try getAPIToken(app)
		defer { app.shutdown() }

		let headers = HTTPHeaders([("Authorization", "Bearer \(token)")])

		let newCategory = BlogCategoryModel.CreateContent(title: "Test Category")

		try app.test(.POST, "/api/blog/categories", headers: headers, content: newCategory) { res in
			XCTAssertEqual(res.status, .ok)
			let contentType = try XCTUnwrap(res.headers.contentType)
			XCTAssertEqual(contentType, .json)
			XCTAssertContent(BlogCategoryModel.CreateContent.self, res) { content in
				XCTAssertEqual(content.title, newCategory.title)
			}
		}
	}
}
