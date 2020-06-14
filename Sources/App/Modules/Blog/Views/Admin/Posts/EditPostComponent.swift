import Plot
import ViewKit

struct EditPostComponent: HTMLViewComponent {

	let post: BlogPostEditForm?

	private var isEditing: Bool {
		post != nil
	}

	private var previewLink: HTMLBodyNode {
		guard let post = post else { return .empty }
		guard !post.slug.value.isEmpty else { return .empty }
		return .a(.href("/\(post.slug.value)"), .target(.blank), "Preview")
	}

	private var imageInput: Node<HTML.FormContext> {
		.section(
			.label(.for("image"), "Image"),
			.div(
				.id("image-uploader"),
				.class("image-uploader"),
				.unwrap(post?.image.value, {
					.if(!$0.isEmpty, .img(.src($0)))
				}),
				.a(
					.id("choose-button"),
					.href("javascript:void(0);"),
					.onclick("chooseImage();"),
					"Choose"
				),
				" ",
				.a(
					.id("remove-button"),
					.href("javascript:void(0);"),
					.onclick("removeImage();"),
					"Remove"
				),
				.input(
					.id("imageDelete"),
					.name("imageDelete"),
					.type(.hidden),
					.value("false")
				),
				.input(
					.id("image"),
					.name("image"),
					.type(.file),
					.attribute(named: "accept", value: "image/jpeg"),
					.attribute(named: "style", value: "display:none;")
				)
			)
		)
	}

	private var categoryInput: Node<HTML.FormContext> {
		Node<HTML.FormContext>.section(
			.label(.for("categoryId"), "Category"),
			.select(
				.attribute(named: "name", value: "categoryId"),
				.forEach(post?.categoryId.options ?? [], { (option: FormFieldOption) in
					.option(.value(option.key), .isSelected(option.key == post?.categoryId.value), .label(option.label))
				})
			),
			showError(formField: post?.categoryId)
		)
	}

	private var scripts: HTMLBodyNode {
		.script(
			"""
			function chooseImage() {
				document.getElementById('imageDelete').value = false;
				document.getElementById('image').click();
			}
			function removeImage() {
				document.getElementById('image').value = null;
				document.getElementById('imageDelete').value = true;
				const element = document.getElementById('uploaded-image');
				if (element !== null) {
					element.parentNode.removeChild(element);
				}
			}

			document.getElementById("image")
			.onchange = function(event) {
				const file = event.target.files[0];
				const blobURL = URL.createObjectURL(file);
				let element = document.getElementById('uploaded-image');
				if (element === null) {
					var newElement = document.createElement("img");
					newElement.id = 'uploaded-image';
					const sibling = document.getElementById('choose-button');
					sibling.parentNode.insertBefore(newElement, sibling);
					element = newElement
				}
				element.src = blobURL;
			}
			"""
		)
	}

	var component: HTMLBodyNode {
		.group([
			.div(
				.class("wrapper"),
				.h2(
					.a(.href("/admin/blog/posts"), "Posts"),
					.if(isEditing,
						" / Edit",
						else: " / Create")
				),
				previewLink
			),

			.form(
				.id("post-edit-form"),
				.class("wrapper"),
				.method(.post),
				.action("/admin/blog/posts/\(post?.id ?? "new")"),
				.enctype(.multipartData),
				.input(
					.type(.hidden),
					.name("id"),
					.unwrap(post?.id, { .value($0)} )
				),

				input(id: "title", label: "Title", isRequired: true, formField: post?.title),
				input(id: "slug", label: "Slug", isRequired: true, formField: post?.slug),

				imageInput,

				textarea(id: "excerpt", label: "Excerpt", formField: post?.excerpt),
				textarea(id: "content", label: "Content", formField: post?.content),

				input(id: "date", label: "Date", isRequired: true, formField: post?.date),

				categoryInput,

				.section(
					.input(.type(.submit), .class("submit"), .value("Save"))
				)
			),
			scripts
		])
	}

	func showError<T: HTML.BodyContext>(formField: FormField?) -> Node<T> {
		.unwrap(formField?.error, {
			.span(.class("error"), .text($0))
		})
	}

	func input(id: String, label: String, isRequired: Bool = false, formField: BasicFormField?) -> Node<HTML.FormContext> {
		.section(
			.label(
				.for(id),
				.text(label),
				.if(isRequired, .span(.class("requried"), " (required)"))
			),
			.input(
				.id(id),
				.type(.text),
				.name(id),
				.value("\(formField?.value ?? "")"),
				.class("field")
			),
			showError(formField: formField)
		)
	}

	func textarea(id: String, label: String, isRequired: Bool = false, formField: BasicFormField?) -> Node<HTML.FormContext> {
		.section(
			.label(.for(id), .text(label)),
			.textarea(
				.name(id),
				.class("small"),
				"\(formField?.value ?? "")"
			),
			showError(formField: formField)
		)
	}
}
