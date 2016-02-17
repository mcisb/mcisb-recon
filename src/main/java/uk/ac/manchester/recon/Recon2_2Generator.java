package uk.ac.manchester.recon;

import java.io.*;
import java.util.*;
import javax.xml.stream.*;
import org.mcisb.ontology.*;
import org.mcisb.ontology.sbo.*;
import org.mcisb.sbml.*;
import org.mcisb.subliminal.model.*;
import org.mcisb.subliminal.shorthand.*;
import org.sbml.jsbml.*;
import org.sbml.jsbml.CVTerm.*;

/**
 * 
 * @author Neil Swainston
 */
public class Recon2_2Generator
{
	/**
	 * 
	 * @param document
	 * @throws Exception
	 */
	private static void initialise( final SBMLDocument document ) throws Exception
	{
		final Model model = document.getModel();
		model.setId( "recon2_2" ); //$NON-NLS-1$
		model.setName( "Recon 2.2" ); //$NON-NLS-1$
		model.unsetNotes();
		
		model.unsetAnnotation();
		SbmlUtils.addOntologyTerm( model, OntologyUtils.getInstance().getOntologyTerm( Ontology.TAXONOMY, "9606" ), Type.BIOLOGICAL_QUALIFIER, Qualifier.BQB_OCCURS_IN ); //$NON-NLS-1$
		
		final History modelHistory = model.getHistory();
		modelHistory.setCreatedDate( Calendar.getInstance().getTime() );
		modelHistory.addModifiedDate( Calendar.getInstance().getTime() );
		
		final Creator swainston = new Creator();
		swainston.setGivenName( "Neil" ); //$NON-NLS-1$
		swainston.setFamilyName( "Swainston" ); //$NON-NLS-1$
		swainston.setOrganisation( "University of Manchester" ); //$NON-NLS-1$
		swainston.setEmail( "neil.swainston@manchester.ac.uk" ); //$NON-NLS-1$
		modelHistory.addCreator( swainston );
		
		final Creator smallbone = new Creator();
		smallbone.setGivenName( "Kieran" ); //$NON-NLS-1$
		smallbone.setFamilyName( "Smallbone" ); //$NON-NLS-1$
		smallbone.setOrganisation( "University of Manchester" ); //$NON-NLS-1$
		smallbone.setEmail( "kieran.smallbone@manchester.ac.uk" ); //$NON-NLS-1$
		modelHistory.addCreator( smallbone );
		
		final Creator hefzi = new Creator();
		hefzi.setGivenName( "Hooman" ); //$NON-NLS-1$
		hefzi.setFamilyName( "Hefzi" ); //$NON-NLS-1$
		hefzi.setOrganisation( "University of California, San Diego" ); //$NON-NLS-1$
		hefzi.setEmail( "hhefzi@ucsd.edu" ); //$NON-NLS-1$
		modelHistory.addCreator( hefzi );
		
		final Creator dobson = new Creator();
		dobson.setGivenName( "Paul" ); //$NON-NLS-1$
		dobson.setFamilyName( "Dobson" ); //$NON-NLS-1$
		dobson.setOrganisation( "University of Manchester" ); //$NON-NLS-1$
		dobson.setEmail( "paul.dobson@manchester.ac.uk" ); //$NON-NLS-1$
		modelHistory.addCreator( dobson );
		
		for( Reaction reaction : model.getListOfReactions() )
		{
			// Delete evidence codes:
			final Map<OntologyTerm,Object[]> ontologyTerms = SbmlUtils.getOntologyTerms( reaction );
			reaction.unsetAnnotation();
			
			for( Iterator<Map.Entry<OntologyTerm,Object[]>> iterator = ontologyTerms.entrySet().iterator(); iterator.hasNext(); )
			{
				final Map.Entry<OntologyTerm,Object[]> entry = iterator.next();
				
				if( entry.getKey().getOntologyName().equals( Ontology.EVIDENCE_CODE ) )
				{
					iterator.remove();
				}
			}
			
			SbmlUtils.addOntologyTerms( reaction, ontologyTerms );
			
			// Delete error-inducing GENE_ASSOCIATION:
			final String GENE_ASSOCIATION = "GENE_ASSOCIATION"; //$NON-NLS-1$
			final String PROBLEMATIC_PATTERN = "HG\\d+ - HT\\d+ or "; //$NON-NLS-1$
			final String EMPTY_STRING = ""; //$NON-NLS-1$
			final Object geneAssociation = SbmlUtils.getNotes( reaction ).get( GENE_ASSOCIATION );
			
			if( geneAssociation instanceof String )
			{
				SbmlUtils.set( reaction, GENE_ASSOCIATION, ( (String)geneAssociation ).replaceAll( PROBLEMATIC_PATTERN, EMPTY_STRING ) );
			}
		}

		stripNotes( document );
	}
	
	/**
	 * 
	 * @param in
	 * @param merge
	 * @return SBMLDocument
	 * @throws Exception
	 */
	private static SBMLDocument stripNotes( final SBMLDocument in ) throws Exception
	{
		final Model inModel = in.getModel();
		
		stripNotes( inModel.getListOfCompartments() );
		stripNotes( inModel.getListOfSpecies() );
		stripNotes( inModel.getListOfReactions() );
		
		return in;
	}
	
	/**
	 * 
	 * @param recon2_1_listOfSBases
	 * @param recon2_listOfSBases
	 * @throws UnsupportedEncodingException
	 * @throws XMLStreamException
	 */
	private static void stripNotes( final ListOf<?> inListOfSBases ) throws UnsupportedEncodingException, XMLStreamException
	{
		final String EMPTY_STRING = ""; //$NON-NLS-1$
		
		for( Object sbase : inListOfSBases )
		{
			final NamedSBase inNamedSBase = ( (NamedSBase)sbase );
			final Map<String,Object> notes = SbmlUtils.getNotes( inNamedSBase );
			final Map<String,Object> updatedNotes = new HashMap<>();
			inNamedSBase.unsetNotes();
			
			// Strip out empty notes:
			for( Map.Entry<String,Object> entry : notes.entrySet() )
			{
				final String key = entry.getKey().trim();
				String value = entry.getValue().toString().trim();
				
				if( ( key.length() > 0 && value.length() > 0 ) 
					|| key.equals( "GENE_ASSOCIATION" ) ) //$NON-NLS-1$
				{
					if( key.equals( SbmlUtils.SUBSYSTEM ) && value.equals( "Unassigned" ) ) //$NON-NLS-1$
					{
						value = EMPTY_STRING;
					}
					
					updatedNotes.put( key, value );
				}
			}
			
			updatedNotes.remove( "CARBONS" ); //$NON-NLS-1$
			updatedNotes.remove( "EHMN" ); //$NON-NLS-1$
			updatedNotes.remove( "EHMN_ABBREVIATION" ); //$NON-NLS-1$
			updatedNotes.remove( "HEPATONET" ); //$NON-NLS-1$
			updatedNotes.remove( "HEPATONET_1.0_ABBREVIATION" ); //$NON-NLS-1$
			updatedNotes.remove( "AUTHORS" ); //$NON-NLS-1$
			updatedNotes.remove( "Confidence Level" ); //$NON-NLS-1$
			updatedNotes.remove( "EC Number" ); //$NON-NLS-1$
			
			SbmlUtils.setNotes( inNamedSBase, updatedNotes );
		}
	}
	
	/**
	 * 
	 * @param args
	 * @throws Exception 
	 */
	public static void main( String[] args ) throws Exception
	{
		// Recon 2.2:
		final SBMLDocument document = SBMLReader.read( new File( args[ 0 ] ) );
		final Model model = document.getModel();
		
		// Format Recon 2.2:
		System.out.println( "Initialising document..." ); //$NON-NLS-1$
		initialise( document );
		System.out.println();
		
		// Check:
		System.out.println( "Checking annotation validity..." ); //$NON-NLS-1$
		SbmlUpdater.checkAnnotationValidity( model );
		System.out.println();
		
		// Create:
		System.out.println( "Creating compartments..." ); //$NON-NLS-1$
		SbmlCreator.createCompartments( model, new File( args[ 2 ] ) );
		System.out.println();
		
		System.out.println( "Creating species..." ); //$NON-NLS-1$
		SbmlCreator.createSpecies( model, new File( args[ 3 ] ) );
		System.out.println();
		
		System.out.println( "Creating reactions..." ); //$NON-NLS-1$
		SbmlCreator.createReactions( model, new File( args[ 4 ] ) );
		System.out.println();
		
		System.out.println( "Reformatting charges..." ); //$NON-NLS-1$
		SbmlUpdater.updateCharges( model );
		System.out.println();
		
		System.out.println( "Reformatting formulae..." ); //$NON-NLS-1$
		SbmlUpdater.updateFormulae( model );
		System.out.println();
		
		System.out.println( "Reformatting species SBO terms..." ); //$NON-NLS-1$
		SbmlUpdater.updateSBOTerms( Arrays.asList( model.getListOfSpecies().toArray( new SBase[ model.getListOfSpecies().size() ]) ), SboUtils.SIMPLE_CHEMICAL );
		System.out.println();
		
		System.out.println( "Updating annotations..." ); //$NON-NLS-1$
		SbmlUpdater.updateAnnotations( model, new File( args[ 5 ] ) );
		System.out.println();
		
		System.out.println( "Updating formulae and charges from annotations..." ); //$NON-NLS-1$
		SbmlUpdater.updateFromAnnotations( model );
		System.out.println();
		
		System.out.println( "Updating formulae..." ); //$NON-NLS-1$
		SbmlUpdater.updateFormulae( model, new File( args[ 6 ] ) );
		System.out.println();
		
		System.out.println( "Updating charges..." ); //$NON-NLS-1$
		SbmlUpdater.updateCharges( model, new File( args[ 7 ] ) );
		System.out.println();
		
		System.out.println( "Updating inchis..." ); //$NON-NLS-1$
		SbmlUpdater.updateInchis( model, new File( args[ 8 ] ) );
		System.out.println();
		
		System.out.println( "Updating boundary conditions..." ); //$NON-NLS-1$
		SbmlUpdater.updateBoundaryConditions( model );
		System.out.println();
		
		System.out.println( "Updating reaction SBO terms..." ); //$NON-NLS-1$
		SbmlUpdater.updateReactionSBOTerms( model );
		System.out.println();
		
		System.out.println( "Updating reactions..." ); //$NON-NLS-1$
		SbmlUpdater.updateReactions( model, new File( args[ 9 ] ) );
		System.out.println();

		System.out.println( "Updating reversibilities..." ); //$NON-NLS-1$
		SbmlUpdater.updateReversibilities( model, new File( args[ 10 ] ) );
		System.out.println();
		
		System.out.println( "Updating flux bounds..." ); //$NON-NLS-1$
		FluxBoundsGenerater.run( model );
		System.out.println();
		
		// Reformat:
		System.out.println( "Reformatting inchis..." ); //$NON-NLS-1$
		SbmlReformatter.reformatInchis( model );
		System.out.println();
		
		// Check:
		System.out.println( "Checking annotation accuracy..." ); //$NON-NLS-1$
		SbmlUpdater.checkAnnotationAccuracy( model );
		System.out.println();
		
		System.out.println( "Checking annotation consistency..." ); //$NON-NLS-1$
		SbmlUpdater.checkAnnotationConsistency( model );
		System.out.println();
		
		// Delete:
		System.out.println( "Deleting modifiers..." ); //$NON-NLS-1$
		SbmlDeleter.deleteModifiers( model );
		System.out.println();
		
		System.out.println( "Deleting species and related reactions..." ); //$NON-NLS-1$
		SbmlDeleter.deleteSpecies( model, new File( args[ 12 ] ) , true );
		System.out.println();
		
		System.out.println( "Deleting species..." ); //$NON-NLS-1$
		SbmlDeleter.deleteSpecies( model, new File( args[ 13 ] ) , false );
		System.out.println();
		
		System.out.println( "Deleting reactions..." ); //$NON-NLS-1$
		SbmlDeleter.deleteReactions( model, new File( args[ 14 ] ) );
		System.out.println();
		
		System.out.println( "Cleaning document: rebalancing, fixing -R groups, deleting unbalanced, dead-end metabolites..." ); //$NON-NLS-1$
		final int MAX_STOICH_COEFF = 6;
		SbmlDeleter.clean( document, MAX_STOICH_COEFF );
		System.out.println();
		
		System.out.println( "Deleting duplicate species..." ); //$NON-NLS-1$
		SbmlDeleter.deleteDuplicateSpecies( model );
		System.out.println();
		
		System.out.println( "Deleting duplicate reactions..." ); //$NON-NLS-1$
		SbmlDeleter.deleteDuplicateReactions( model );
		System.out.println();
		
		System.out.println( "Deleting pointless reactions..." ); //$NON-NLS-1$
		SbmlDeleter.deletePointlessReactions( model );
		System.out.println();
		
		System.out.println( "Deleting orphan species..." ); //$NON-NLS-1$
		SbmlDeleter.deleteOrphanSpecies( model );
		System.out.println();
		
		// Update:
		System.out.println( "Renaming species names..." ); //$NON-NLS-1$
		SbmlUpdater.updateSpeciesNames( model, new File( args[ 15 ] ) );
		System.out.println();
		
		System.out.println( "Renaming reaction names..." ); //$NON-NLS-1$
		SbmlUpdater.updateReactionNames( model, new File( args[ 16 ] ) );
		System.out.println();
		
		System.out.println( "Renaming species ids..." ); //$NON-NLS-1$
		SbmlUpdater.updateSpeciesIds( model, new File( args[ 17 ] ) );
		System.out.println();
		
		System.out.println( "Renaming reaction ids..." ); //$NON-NLS-1$
		SbmlUpdater.updateReactionIds( model, new File( args[ 18 ] ) );
		System.out.println();
		
		System.out.println( "Updating gene associations..." ); //$NON-NLS-1$
		SbmlUpdater.updateGeneAssociations( model, new File( args[ 11 ] ) );
		System.out.println();
		
		// Reformat:
		System.out.println( "Checking meta ids..." ); //$NON-NLS-1$
		SbmlDeleter.checkMetaIds( document );
		System.out.println();

		// Write:
		System.out.println( "Writing Recon 2.2 to file..." ); //$NON-NLS-1$
		XmlFormatter.getInstance().write( document, new File( args[ 1 ] ) );
	}
}