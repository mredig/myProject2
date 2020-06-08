@testable import App
import Spec
import Fluent

final class BlogPostApiTests: AppTestCase {

	func testGetPosts() throws {
		let app = try createTestApp()
		let token = try getAPIToken(app)
		defer { app.shutdown() }

		try app
			.describe("Blog posts should return ok")
			.get("/api/blog/posts")
			.bearerToken(token)
			.expect(.ok)
			.expect(.json)
			.expect(Page<BlogPostModel.ListItem>.self) { content in
				print(content)
			}
			.test()
	}

	func testCreatePost() throws {
		let app = try createTestApp()
		let token = try getAPIToken(app)
		defer { app.shutdown() }

		let c = try BlogCategoryModel.query(on: app.db).first().wait()
		guard let category = c else {
			XCTFail("Missing default category")
			throw Abort(.notFound)
		}

		let newPost = BlogPostModel.CreateContent(title: "Dummy Post",
												  slug: "dummy-slug",
												  image: "/dummy/image.jpg",
												  excerpt: "Lorem Ipsum",
												  date: Date(),
												  content: "Lorem Ipsum",
												  categoryId: category.id!.uuidString)

		var total = 1

		try app
			.describe("Get original posts count")
			.get("/api/blog/posts")
			.bearerToken(token)
			.expect(.ok)
			.expect(.json)
			.expect(Page<BlogPostModel.ListItem>.self) { content in
				total += content.metadata.total
			}
			.test()

		try app
			.describe("Create post should return ok")
			.post("/api/blog/posts")
			.body(newPost)
			.bearerToken(token)
			.expect(.ok)
			.expect(.json)
			.expect(BlogPostModel.GetContent.self) { content in
				XCTAssertEqual(content.title, newPost.title)
			}
			.test()

		try app
			.describe("Blog post count should be updated")
			.get("/api/blog/posts")
			.bearerToken(token)
			.expect(.ok)
			.expect(.json)
			.expect(Page<BlogPostModel.ListItem>.self) { content in
				XCTAssertEqual(content.metadata.total, total)
			}
			.test()
	}

	func testUpdatePost() throws {
		let app = try createTestApp()
		let token = try getAPIToken(app)
		defer { app.shutdown() }
		
		let post = try BlogPostModel
			.query(on: app.db)
			.with(\.$category)
			.first()
			.unwrap(or: Abort(.notFound))
			.wait()

		let suffix = " updated"

		let newPost = BlogPostModel.UpdateContent(title: post.title + suffix,
												  slug: post.slug + suffix,
												  image: post.image + suffix,
												  excerpt: post.excerpt + suffix,
												  date: post.date,
												  content: post.content + suffix,
												  categoryId: post.category.id!.uuidString)

		try app
			.describe("Update post should return okay")
			.put("/api/blog/posts/\(post.id!.uuidString)")
			.body(newPost)
			.bearerToken(token)
			.expect(.ok)
			.expect(.json)
			.expect(BlogPostModel.GetContent.self) { content in
				XCTAssertEqual(content.id, post.id)
				XCTAssertEqual(content.title, newPost.title)
				XCTAssertEqual(content.slug, newPost.slug)
				XCTAssertEqual(content.image, newPost.image)
				XCTAssertEqual(content.excerpt, newPost.excerpt)
				XCTAssertEqual(content.date, newPost.date)
				XCTAssertEqual(content.content, newPost.content)
			}
			.test()
	}

}
