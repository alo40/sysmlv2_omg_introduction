import syside

model, _ = syside.load_model(["/Users/alejandronietocuatenta/Documents/sysmlv2_omg_introduction/omg_requirements_example/syside_requirements.sysml"])


def source_of(element: syside.Element) -> str:
    if (text_doc := element.document.text_document) and (cst := element.cst_node):
        with text_doc.lock() as source_text:
            return cst.text(source_text.text)
    return str(element)


def evaluate_satisfaction(vehicle: syside.PartUsage) -> None:
    SatisfyRequirementUsage = vehicle.children.elements[-1].cast(syside.SatisfyRequirementUsage)
    compiler = syside.Compiler()

    for i, membership in enumerate(SatisfyRequirementUsage.feature_memberships.collect()):
        
        # Original
        if not isinstance(membership, syside.RequirementConstraintMembership):
            # print(f"NO REQ MEMBERSHIP {i} {membership}")
            continue
        # else: 
            # print(f"{i} {membership}")

        outer = membership.owned_constraint
        assert outer, "Invariant violated"
        print(f"#. {outer}")

        # Syside does not yet support user-functions thus we need to evaluate
        # result expressions manually within correct scope. However, doing it
        # this way will lose invoked function scope, therefore we manually
        # override parameters to correct values and use the invoked function as
        # the scope.
        (
            outer.children.elements[0].cast(syside.Usage)
            .feature_value_member.set_member_element(syside.FeatureReferenceExpression)[1]
            .referent_member.set_member_element(vehicle)
        )
        for i, inner in enumerate(outer.feature_memberships.collect()):
            if not isinstance(inner, syside.RequirementConstraintMembership):
                continue
            # print(f"{i} {inner}")

            constraint = inner.owned_constraint
            assert constraint, "Invariant violated"

            expr = constraint.result_expression
            if not expr:
                continue

            value, report = compiler.evaluate(
                expr, scope=outer, experimental_quantities=True
            )

            if not report:
                print(f"  - `{source_of(expr)}` failed: {report.diagnostics}")
                continue
            print(f"  - `{source_of(expr)}` -> {value}")


with model.user_docs[0].lock() as doc:
    evaluate_satisfaction(
        doc.root_node["Syside Requirement Example"]
        .cast(syside.Namespace)["vehicle_c1"]
        .cast(syside.PartUsage)
    )